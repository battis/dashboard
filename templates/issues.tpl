{assign var="issue_count" value=count($issues)}
{assign var="plural" value="s"}
{if $issue_count == 1}{$plural=""}{/if}
{assign var="category" value="$issue_count Issue$plural"}
{extends file="subpage.tpl"}

{block name="subcontent"}

	<div class="container">
		<table class="table table-striped table-hover sortable">
			<thead>
				<th>Issue</th>
				<th>Due</th>
				<th class="sorting-placeholder"></th>
			</thead>
			<tbody>
				{foreach $issues as $issue}
					<tr>
						<td>
							<h4><a href="{$issue['html_url']}">{$issue['title']}</a>
							{foreach $issue['labels'] as $label}
								<span class="label label-default" style="background-color: #{$label['color']};">{$label['name']}</span>
							{/foreach}</h4>
							<p>#{$issue['number']} opened {$issue['created_at']|date_format:'F, j Y'} by {$issue['user']['login']}{if !empty($issue['milestone'])} in milestone <a href="{$issue['milestone']['html_url']}">{$issue['milestone']['title']}</a>{/if}</p>
						</td>
						{if empty($issue['milestone']['due_on'])}
							<td class="sorting-placeholder"></td>
							<td></td>
						{else}
							<td data-dateformat="Y-m-d" class="sorting-placeholder">
								{$issue['milestone']['due_on']|date_format:'Y-m-d'}
							</td>
							<td>
								{$issue['milestone']['due_on']|date_format:'l, F j, Y'|default:''}
							</td>
						{/if}
					</tr>
				{/foreach}
			</tbody>
		</table>
	</div>

{/block}