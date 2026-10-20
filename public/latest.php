<?php
// Tells the site which Tidemark release is newest, so the version on the download buttons stays current without a rebuild.
// Asks GitHub at most once an hour and keeps the answer in a temp file; visitors' browsers only ever talk to this site.
declare(strict_types=1);

const REPO = 'tidemark-analytics/tidemark';
const TTL = 3600;

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: public, max-age=900');
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

$body = false;
$api = 'https://api.github.com/repos/' . REPO . '/releases/latest';
$headers = ['Accept: application/vnd.github+json', 'User-Agent: tidemark-site'];
if (function_exists('curl_init')) {
    $ch = curl_init($api);
    curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 6, CURLOPT_CONNECTTIMEOUT => 4, CURLOPT_FOLLOWLOCATION => true, CURLOPT_HTTPHEADER => $headers]);
    $body = curl_exec($ch);
    if (curl_getinfo($ch, CURLINFO_RESPONSE_CODE) !== 200) {
        $body = false;
    }
    curl_close($ch);
} elseif (ini_get('allow_url_fopen')) {
    $body = @file_get_contents($api, false, stream_context_create(['http' => ['timeout' => 6, 'header' => implode("\r\n", $headers)]]));
}

$release = is_string($body) ? json_decode($body, true) : null;
$tag = is_array($release) ? (string) ($release['tag_name'] ?? '') : '';
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
