{assign var="labels" value=array()}
{extends file="page.tpl"}

{block name="content"}

	<div class="container page-header">
		<h1>{$user} <small><span id="issue_count">{count($issues)}</span> Issues</small></h1>
	</div>

	<div class="container">
		<p><span class="glyphicon glyphicon-filter"></span> <span id="labels"></span> <a href="javascript:github_dashboard.clearFilters();" class="btn btn-xs btn-default pull-right">Clear Filters</a></p>
		<table class="table table-striped table-hover sortable">
			<thead>
				<th>Repository</th>
				<th>Issue</th>
				<th>Comments</th>
				<th data-firstsort="desc">Due Date</th>
			</thead>
			<tbody>
				{foreach $issues as $issue}
					{assign var="repository" value=str_replace('https://api.github.com/repos/', '' , $issue['repository_url'])}
					<tr>
						<td class="sorting-placeholder">
							{$repository}
						</td>
						<td colspan="2">
							<h4>
								<a target="_blank" href="{$issue['html_url']}">{$issue['title']}</a>
								{foreach $issue['labels'] as $label}
									{if empty($labels[$label['name']])}
										{$labels[$label['name']] = "'{$label['name']}':'#{$label['color']}'"}
									{/if}
									<a href="javascript:github_dashboard.filter('label', '{$label['name']}');" class="label label-{preg_replace('/[^a-zA-Z0-9_\-]+/', '-', $label['name'])}" style="background-color: #{$label['color']};">{$label['name']}</a>
								{/foreach}
							</h4>
							<h5 class="repository"><a target="_blank" href="https://github.com/{$repository}">{$repository}</a> {filterAndRemoveButtons('repository', $repository)}</h5>
							<p>#{$issue['number']} opened {$issue['created_at']|date_format:'F, j Y'} by <span class="user">{$issue['user']['login']} {filterAndRemoveButtons('user', $issue['user']['login'])}</span>{if !empty($issue['milestone'])} in milestone <a target="_blank" href="{$issue['milestone']['html_url']}" class="milestone">{$issue['milestone']['title']}</a> {filterAndRemoveButtons('milestone', $issue['milestone']['title'])}{else}<span class="milestone"></span>{/if}</p>
						</td>
						<td class="comments">
							<span class="glyphicon glyphicon-comment"></span> {$issue['comments']}
						</td>
						<td data-value="{$issue['milestone']['due_on']|date_format:'Y-m-d'|default:''}" class="due_date">
							{assign var="due_date" value=$issue['milestone']['due_on']|date_format:'l, F j, Y'|default:'n/a'}
							<span{if $due_date == 'n/a'} class="sorting-placeholder"{/if}>{$due_date}</span>
							{filterAndRemoveButtons('due_date', $due_date)}
						</td>
					</tr>
				{/foreach}
			</tbody>
		</table>
	</div>
	
{/block}

{block name="post-bootstrap-scripts"}

	<script src="js/issues.js"></script>
	<script>
		
		github_dashboard.buildLabelList({ {implode(' , ', $labels)} });
		
	</script>

{/block}