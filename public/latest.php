<?php
// Tells the site which Tidemark release is newest, so the version on the download buttons stays current without a rebuild.
// Asks GitHub at most once an hour and keeps the answer in a temp file; visitors' browsers only ever talk to this site.
declare(strict_types=1);

const REPO = 'tidemark-analytics/tidemark';
const TTL = 600;

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: public, max-age=300');
header('X-Content-Type-Options: nosniff');

$cache = sys_get_temp_dir() . '/tidemark-site-latest-' . md5(__DIR__) . '.json';
$read = static function () use ($cache): ?array {
    $d = is_file($cache) ? json_decode((string) file_get_contents($cache), true) : null;
    return is_array($d) && isset($d['version'], $d['url'], $d['at']) ? $d : null;
};
$send = static function (array $d): never {
    echo json_encode(['version' => $d['version'], 'url' => $d['url']], JSON_UNESCAPED_SLASHES);
    exit;
};

$cached = $read();
if ($cached && time() - (int) $cached['at'] < TTL) {
    $send($cached);
}

$ua = 'tidemark-site';
$tag = '';

// 1. github.com/<repo>/releases/latest answers with a redirect to the newest tag. Unlike the API it has no tight anonymous
//    rate limit, which shared hosts (many sites behind one IP) tend to exhaust.
$location = '';
$page = 'https://github.com/' . REPO . '/releases/latest';
if (function_exists('curl_init')) {
    $ch = curl_init($page);
    curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_HEADER => true, CURLOPT_NOBODY => true, CURLOPT_FOLLOWLOCATION => false, CURLOPT_TIMEOUT => 6, CURLOPT_CONNECTTIMEOUT => 4, CURLOPT_USERAGENT => $ua]);
    $out = curl_exec($ch);
    if (is_string($out) && preg_match('/^location:\s*(\S+)/mi', $out, $m)) {
        $location = $m[1];
    }
} elseif (ini_get('allow_url_fopen')) {
    @file_get_contents($page, false, stream_context_create(['http' => ['method' => 'HEAD', 'follow_location' => 0, 'timeout' => 6, 'header' => "User-Agent: $ua"]]));
    foreach ($http_response_header ?? [] as $h) {
        if (stripos($h, 'location:') === 0) {
            $location = trim(substr($h, 9));
        }
    }
}
if (preg_match('#/releases/tag/(v?\d+\.\d+\.\d+[^/?\s]*)$#', $location, $m)) {
    $tag = rawurldecode($m[1]);
}

// 2. Fall back to the API.
if ($tag === '') {
    $body = false;
    $api = 'https://api.github.com/repos/' . REPO . '/releases/latest';
    if (function_exists('curl_init')) {
        $ch = curl_init($api);
        curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 6, CURLOPT_CONNECTTIMEOUT => 4, CURLOPT_FOLLOWLOCATION => true, CURLOPT_HTTPHEADER => ['Accept: application/vnd.github+json', "User-Agent: $ua"]]);
        $body = curl_exec($ch);
        if (curl_getinfo($ch, CURLINFO_RESPONSE_CODE) !== 200) {
            $body = false;
        }
    } elseif (ini_get('allow_url_fopen')) {
        $body = @file_get_contents($api, false, stream_context_create(['http' => ['timeout' => 6, 'header' => "Accept: application/vnd.github+json\r\nUser-Agent: $ua"]]));
    }
    $release = is_string($body) ? json_decode($body, true) : null;
    $tag = is_array($release) ? (string) ($release['tag_name'] ?? '') : '';
}

if (preg_match('/^v?(\d+\.\d+\.\d+(?:[-+][\w.]+)?)$/', $tag, $m)) {
    $fresh = ['version' => $m[1], 'url' => 'https://github.com/' . REPO . '/releases/tag/' . rawurlencode($tag), 'at' => time()];
    @file_put_contents($cache, json_encode($fresh), LOCK_EX);
    $send($fresh);
}

if ($cached) {
    $send($cached); // GitHub is unreachable: serve the last answer we had
}
http_response_code(503);
echo '{}';
