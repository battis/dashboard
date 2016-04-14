var github_dashboard = {
	buildLabelList: function() {
		$('#labels').empty();
		$('tbody h4 .label:visible').each(function() {
			var classes = $(this).attr('class').split(' ');
			if ($('#labels .' + classes[1]).length == 0) {
				$('#labels').append(
					' <a class="' + $(this).attr('class') + '" style="background-color: ' + $(this).css('background-color') + ';" href="javascript:github_dashboard.filter(\'label\', \'' + $(this).text() + '\');">' +
						$(this).text() +
					'</a>'
				);
			}
		});
		$('#labels .label').each(function() {
			$(this).text($(this).text() + ' (' + $('tbody .' + $(this).attr('class').replace(' ', '.') + ':visible').length + ')');
		});
	},
	
	filter: function(facet, value) {
		$('tbody tr:has(.' + facet + ':not(:contains(' + value + '))):not(:has(.' + facet + ':contains(' + value + '))):visible').hide();
		this.updateCount();
	},
	
	remove: function(facet, value) {
		$('tbody tr:has(.' + facet + ':contains("' + value + '")):visible').hide();
		this.updateCount();
	},
	
	clearFilters: function() {
		$('tbody tr').show();
		this.updateCount();
	},
	
	updateCount: function() {
		$('#issue_count').text($('tbody tr:visible').length);
		this.buildLabelList();
	}
};

$(github_dashboard.updateCount());
