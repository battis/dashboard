<?php
	
require_once 'common.inc.php';

$issues = array();
try {

	$issues = json_decode(
		$github->get(
			'/issues'
		),
		true
	);

	do {
		preg_match('%<https://api.github.com([^>]+)>;\srel="next"%', $github->last_headers['link'], $next);
		if (!empty($next[1])) {
			$page = json_decode($github->get($next[1]), true);
			$issues = array_merge($issues, $page);
		}
	} while (!empty($next[1]));
	
} catch (Exception $e) {

	echo '<pre>';
	var_dump($github->last_request);
	var_dump($github->last_response);
	exit;

}

$smarty->assign('issues', $issues);
$smarty->display('issues.tpl');