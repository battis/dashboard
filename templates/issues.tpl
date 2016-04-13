{assign var="issue_count" value=count($issues)}
{assign var="plural" value="s"}
{if $issue_count == 1}{$plural=""}{/if}
{assign var="category" value="$issue_count Issue$plural"}
{assign var="labels" value=array()}
{extends file="subpage.tpl"}

{block name="subcontent"}

	<div class="container">
		<p>Toggle <span id="labels"></span></p>
		<table class="table table-striped table-hover sortable">
			<thead>
				<th>Issue</th>
				<th data-defaultsort="desc">Due</th>
				<th class="sorting-placeholder"></th>
			</thead>
			<tbody>
				{foreach $issues as $issue}
					<tr>
						<td>
							<h4><a href="{$issue['html_url']}">{$issue['title']}</a>
							{foreach $issue['labels'] as $label}
								{if empty($labels[$label['name']])}
									{$labels[$label['name']] = "'{$label['name']}':'#{$label['color']}'"}
								{/if}
								<span class="label label-{$label['name']}" style="background-color: #{$label['color']};">{$label['name']}</span>
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

{block name="post-bootstrap-scripts"}

	<script>
		
		var labelVisible = { {implode(',', $labels)} };
		
		function toggleLabel(label) {
			if (labelVisible[label]) {
				$('tr:has(span.label-' + label + ')').hide(500);
				labelVisible[label] = false;
			} else {
				$('tr:has(span.label-' + label + ')').show(500);
				labelVisible[label] = true;
			}
		}
		
		var labels = { {implode(',', $labels)} };
		for (var c in labels) {
			if(labels.hasOwnProperty(c)) {
				$('#labels').append(' <span class="label label-default" style="background-color: ' + labels[c] + ';"><a href="javascript:toggleLabel(\'' + c + '\');">' + c + '</></span>');
			}
		}
	</script>

{/block}