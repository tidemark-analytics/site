<?php
// Minimal waitlist endpoint for shared hosting. Appends emails to ../waitlist/emails.csv (outside the web root
// when possible, otherwise to a protected folder). Honeypot + basic validation; no third parties.
declare(strict_types=1);

$redirect = static function (string $to): never { header('Location: ' . $to, true, 303); exit; };

if ($_SERVER['REQUEST_METHOD'] !== 'POST') { $redirect('/cloud/'); }
if (!empty($_POST['website'])) { $redirect('/cloud/thanks/'); } // honeypot: pretend success

$email = strtolower(trim((string)($_POST['email'] ?? '')));
if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 254) { $redirect('/cloud/?error=email#waitlist'); }

$dir = is_dir(dirname(__DIR__) . '/waitlist') || @mkdir(dirname(__DIR__) . '/waitlist', 0750) ? dirname(__DIR__) . '/waitlist' : __DIR__ . '/_waitlist';
if (!is_dir($dir)) { @mkdir($dir, 0750); }
@file_put_contents($dir . '/.htaccess', "Require all denied\n");

$file = $dir . '/emails.csv';
$existing = is_file($file) ? (string)file_get_contents($file) : '';
$known = array_map(static fn (string $l): string => strtok($l, ',') ?: '', preg_split('/\R/', $existing) ?: []);
if (!in_array($email, $known, true)) {
    file_put_contents($file, $email . ',' . gmdate('c') . "\n", FILE_APPEND | LOCK_EX);
}
$redirect('/cloud/thanks/');
