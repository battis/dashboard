{extends file="page.tpl"}

{block name="content"}

	<div class="container page-header">
		<h1>{$user} <small><span id="issue_count">{count($issues)}</span> Issues</small></h1>
	</div>

	<div class="container">
		<p>
			<span class="glyphicon glyphicon-filter"></span>
			<span id="labels"></span>
			<a href="javascript:github_dashboard.clearFilters();" id="clear-filters" class="btn btn-xs btn-default pull-right">
				Clear Filters
				<span class="glyphicon glyphicon-erase"></span>
			</a>
		</p>
		
		<table class="table table-striped table-hover sortable">
			<thead>
				<th class="col-sm-2">Organization</th>
				<th class="col-sm-2">Repository</th>
				<th class="col-sm-4">Issue</th>
				<th class="col-sm-1">Comments</th>
				<th class="col-sm-3" data-firstsort="desc">Due Date</th>
			</thead>
			<tbody>
				{foreach $issues as $issue}
					{assign var="organization" value=basename(dirname($issue['repository_url']))}
					{assign var="repository" value=basename($issue['repository_url'])}
					<tr>
						<td class="sorting-placeholder">
							{$organization}
						</td>
						<td class="sorting-placeholder">
							{$repository}
						</td>
						<td data-value="{$issue['title']}" colspan="3">
							<h4>
								{toggleButton($issue['id'])}
								<a target="_blank" href="{$issue['html_url']}">
									{$issue['title']}
								</a>
								{foreach $issue['labels'] as $label}
									<a
										href="javascript:github_dashboard.filter('label', '{$label['name']}');"
										class="label label-{preg_replace('/[^a-zA-Z0-9_\-]+/', '-', $label['name'])}"
										style="background-color: #{$label['color']};">{$label['name']}</a>
								{/foreach}
							</h4>
							<h5>
								<a class="organization" target="_blank" href="https://github.com/{$organization}">{$organization}</a> {filterAndRemoveButtons('organization', $organization)} / 
								<a class="repository" target="_blank" href="https://github.com/{$organization}/{$repository}">{$repository}</a>
								{filterAndRemoveButtons('repository', $repository)}
							</h5>
							<p>
								#{$issue['number']}
								opened {$issue['created_at']|date_format:'F, j Y'}
								by <span class="user">{$issue['user']['login']} {filterAndRemoveButtons('user', $issue['user']['login'])}</span>
								{if !empty($issue['milestone'])}
									in milestone <a target="_blank" href="{$issue['milestone']['html_url']}" class="milestone">{$issue['milestone']['title']}</a>
									{filterAndRemoveButtons('milestone', $issue['milestone']['title'])}
								{else}
									<span class="milestone"></span>
								{/if}
							</p>
							<div id="body-{$issue['id']}" class="collapse body-collapse">
								<div class="well well-sm">
									{parseMarkdown($issue['body'])}
								</div>
							</div>
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

	<script id="issues-js" src="js/issues.js"></script>
	<script>
		
		$('.well img').addClass('img-responsive');
		$('.well a').attr('target', '_blank');
		
		$('.body-collapse').on('show.bs.collapse', function() {
			$('#toggle-' + $(this).attr('id').substr(5) + ' .glyphicon').removeClass('glyphicon-triangle-right').addClass('glyphicon-triangle-bottom');
		});
		$('.body-collapse').on('hide.bs.collapse', function() {
			$('#toggle-' + $(this).attr('id').substr(5) + ' .glyphicon').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-right');
		});
		
	</script>

{/block}