#!/usr/bin/env bash
# Deploys the Tidemark marketing site and docs from their latest GitHub releases. Run it from cron.
#
#   deploy-sites.sh              deploy whatever is newer than what is installed
#   deploy-sites.sh --dry-run    show what would happen, change nothing
#   deploy-sites.sh --force      reinstall the latest release even if it is already installed
#   deploy-sites.sh --site=docs  only one site (names are listed under SITES below)
#
# What it does for each site: asks GitHub for the latest release, downloads the zip, checks its SHA-256 checksum, unpacks
# it to a temporary folder, sanity-checks it, saves a backup of the files it is about to replace, copies the new files
# over the site, and removes files that the previous release had and the new one doesn't. Anything else in the web root
# (.well-known, error logs, a _waitlist folder, files you added) is left alone.
#
# Needs: bash, curl, unzip, tar, sha256sum (or shasum). No root, no Node, no git.

set -uo pipefail

# ------------------------------------------------------------------------------------------------ configuration
BASE_DIR="${BASE_DIR:-/var/www/a940d06e-b8eb-45d8-b537-d280f9ca4a27}"   # holds both web roots; state lives here, outside them
STATE_DIR="${STATE_DIR:-$BASE_DIR/.deploy}"                                # versions, backups, log, lock
GITHUB_TOKEN="${GITHUB_TOKEN:-}"                                            # optional; raises GitHub's rate limit (not usually needed)
KEEP_BACKUPS=3

# name | GitHub repo | release asset (the zip) | web root
SITES=(
  "site|tidemark-analytics/site|tidemark-site.zip|$BASE_DIR/public_html"
  "docs|tidemark-analytics/docs|tidemark-docs.zip|$BASE_DIR/docs.tidemarkanalytics.com"
)

# ------------------------------------------------------------------------------------------------ helpers
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
DRY=0; FORCE=0; ONLY=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --force) FORCE=1 ;;
    --site=*) ONLY="${arg#--site=}" ;;
    -h|--help) sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

mkdir -p "$STATE_DIR/backups" "$STATE_DIR/state" || { echo "Cannot create $STATE_DIR" >&2; exit 1; }
LOG="$STATE_DIR/deploy.log"
log() { printf '%s  %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S UTC')" "$*" | tee -a "$LOG"; }

# keep the log small
if [ -f "$LOG" ] && [ "$(wc -l < "$LOG")" -gt 2000 ]; then tail -n 1000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"; fi

for tool in curl unzip tar; do
  command -v "$tool" >/dev/null 2>&1 || { log "ERROR: '$tool' is required but not installed"; exit 1; }
done
if command -v sha256sum >/dev/null 2>&1; then SHA() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then SHA() { shasum -a 256 "$1" | cut -d' ' -f1; }
else log "ERROR: sha256sum or shasum is required"; exit 1; fi

# one run at a time (a slow download must not overlap the next cron tick)
LOCK="$STATE_DIR/lock"
if ! mkdir "$LOCK" 2>/dev/null; then
  if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +60 2>/dev/null)" ]; then rm -rf "$LOCK"; mkdir "$LOCK" || exit 0; else exit 0; fi
fi
TMP="$(mktemp -d "${TMPDIR:-/tmp}/tidemark-deploy.XXXXXX")"
trap 'rm -rf "$TMP" "$LOCK"' EXIT

fetch() { # fetch URL DEST
  curl -fsSL --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 300 \
    -H "User-Agent: tidemark-deploy" ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} -o "$2" "$1"
}

STATUS=0

deploy() { # deploy NAME REPO ASSET ROOT
  local name="$1" repo="$2" asset="$3" root="$4"
  local work="$TMP/$name" statefile="$STATE_DIR/state/$name.version" manifest="$STATE_DIR/state/$name.files"
  mkdir -p "$work"

  [ -d "$root" ] || { log "[$name] ERROR: web root $root does not exist"; return 1; }
  [ -w "$root" ] || { log "[$name] ERROR: web root $root is not writable"; return 1; }

  # 1. what is the newest release?
  if ! fetch "https://api.github.com/repos/$repo/releases/latest" "$work/release.json"; then
    log "[$name] ERROR: could not reach GitHub (rate limit or network). Will retry next run."; return 1
  fi
  local tag; tag="$(grep -m1 '"tag_name"' "$work/release.json" | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')"
  if ! printf '%s' "$tag" | grep -Eq '^v?[0-9]+\.[0-9]+\.[0-9]+([-+][A-Za-z0-9.]+)?$'; then
    log "[$name] ERROR: unexpected release tag '$tag'"; return 1
  fi
  local current=""; [ -f "$statefile" ] && current="$(cat "$statefile")"
  if [ "$tag" = "$current" ] && [ "$FORCE" -eq 0 ]; then return 0; fi   # nothing to do; stay quiet
  log "[$name] new release $tag (installed: ${current:-none})"

  # 2. find the zip and its checksum in the release's assets (never trust URLs from anywhere else)
  local base="https://github.com/$repo/releases/download/"
  local zip_url sha_url
  zip_url="$(grep -o '"browser_download_url"[^,}]*' "$work/release.json" | sed -E 's/.*"(https:[^"]+)".*/\1/' | grep -F "/$asset" | grep -v '\.sha256$' | head -1)"
  sha_url="$(grep -o '"browser_download_url"[^,}]*' "$work/release.json" | sed -E 's/.*"(https:[^"]+)".*/\1/' | grep -F "/$asset.sha256" | head -1)"
  case "$zip_url" in "$base"*) ;; *) log "[$name] ERROR: release $tag has no $asset"; return 1 ;; esac
  case "$sha_url" in "$base"*) ;; *) log "[$name] ERROR: release $tag has no $asset.sha256, refusing to install an unverified file"; return 1 ;; esac
  if [ "$DRY" -eq 1 ]; then log "[$name] dry run: would install $tag from $zip_url into $root"; return 0; fi

  # 3. download and verify
  fetch "$zip_url" "$work/$asset" && fetch "$sha_url" "$work/$asset.sha256" || { log "[$name] ERROR: download failed"; return 1; }
  local expected actual
  expected="$(tr -d '\r' < "$work/$asset.sha256" | awk '{print tolower($1)}' | head -1)"
  actual="$(SHA "$work/$asset")"
  if ! printf '%s' "$expected" | grep -Eq '^[0-9a-f]{64}$' || [ "$expected" != "$actual" ]; then
    log "[$name] ERROR: checksum mismatch for $asset (expected $expected, got $actual). Nothing was changed."; return 1
  fi

  # 4. unpack somewhere safe and sanity-check it
  mkdir -p "$work/new"
  unzip -q -o "$work/$asset" -d "$work/new" || { log "[$name] ERROR: could not unzip $asset"; return 1; }
  if [ ! -f "$work/new/index.html" ]; then log "[$name] ERROR: $asset has no index.html at its top level. Nothing was changed."; return 1; fi
  if find "$work/new" \( -name '..' -o -type l \) | grep -q .; then log "[$name] ERROR: $asset contains links or odd paths. Nothing was changed."; return 1; fi
  (cd "$work/new" && find . -type f | sed 's#^\./##' | LC_ALL=C sort) > "$work/new.files"
  [ -s "$work/new.files" ] || { log "[$name] ERROR: $asset is empty"; return 1; }

  # 5. back up what is about to be replaced (files that exist now and are in the new or the previous release)
  local stamp; stamp="$(date -u +%Y%m%d-%H%M%S)"
  local backup="$STATE_DIR/backups/$name-${current:-initial}-$stamp.tgz"
  { cat "$work/new.files"; [ -f "$manifest" ] && cat "$manifest"; } | LC_ALL=C sort -u > "$work/backup.list"
  (cd "$root" && while IFS= read -r f; do [ -e "$f" ] && printf '%s\n' "$f"; done < "$work/backup.list" | tar -czf "$backup" -T - 2>/dev/null) || true
  ls -1t "$STATE_DIR/backups/$name-"*.tgz 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)) | while IFS= read -r old; do rm -f "$old"; done

  # 6. install: copy over, then remove files the previous release had that this one dropped
  if ! (cd "$work/new" && tar -cf - .) | (cd "$root" && tar -xf -); then
    log "[$name] ERROR: copying files failed part-way. Restoring the backup."
    (cd "$root" && tar -xzf "$backup" 2>/dev/null); return 1
  fi
  local removed=0
  if [ -f "$manifest" ]; then
    while IFS= read -r f; do
      if [ -n "$f" ] && ! grep -Fxq -- "$f" "$work/new.files" && [ -f "$root/$f" ]; then rm -f "$root/$f" && removed=$((removed + 1)); fi
    done < "$manifest"
    find "$root" -depth -type d -empty -not -path "$root" -not -path "*/.well-known*" -not -path "*/cgi-bin*" -delete 2>/dev/null || true
  fi
  cp "$work/new.files" "$manifest"
  printf '%s' "$tag" > "$statefile"
  log "[$name] installed $tag ($(wc -l < "$work/new.files" | tr -d ' ') files, $removed removed). Backup: $(basename "$backup")"
}

# ------------------------------------------------------------------------------------------------ run
for entry in "${SITES[@]}"; do
  IFS='|' read -r name repo asset root <<< "$entry"
  if [ -n "$ONLY" ] && [ "$ONLY" != "$name" ]; then continue; fi
  deploy "$name" "$repo" "$asset" "$root" || STATUS=1
done
exit "$STATUS"
