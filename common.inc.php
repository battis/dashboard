<?php
	
require_once(__DIR__ . '/vendor/autoload.php');

use Battis\ConfigXML;
use Battis\BootstrapSmarty\BootstrapSmarty;
use Battis\GitHubDashboard\TokenPest;


$secrets = new ConfigXML(__DIR__ . '/secrets.xml');

$github = $secrets->newInstanceOf(TokenPest::class, '//github');
$github->addHeader('User-Agent', 'github-issue-tracker');

$smarty = BootstrapSmarty::getSmarty(__DIR__ . '/templates');
$smarty->enable(BootstrapSmarty::MODULE_SORTABLE);
$smarty->addStylesheet('css/issues.css');
$smarty->assign('title', 'GitHub Dashboard');