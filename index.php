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

function filterButton($facet, $value) {
	return "<a href=\"javascript:github_dashboard.filter('$facet', '$value');\"><span class=\"glyphicon glyphicon-filter\"></span></a>";
}

function removeButton($facet, $value) {
	return "<a href=\"javascript:github_dashboard.remove('$facet', '$value');\"><span class=\"glyphicon glyphicon-remove\"></span></a>";
}

function filterAndRemoveButtons($facet, $value) {
	return filterButton($facet, $value) . ' ' . removeButton($facet, $value);
}

$smarty->assign('user', $secrets->toArray('//github/user')[0][0]);
$smarty->assign('issues', $issues);
$smarty->assign('category', count($issues) . ' Issue' . (count($issues) == 1 ? '' : 's'));
$smarty->display('issues.tpl');