var github_dashboard = {
	labelVisible: [],
	
	buildLabelList: function(labels) {
		var name;
		
		for (name in labels) {
			if(labels.hasOwnProperty(name)) {
				$('#labels').append(' <a class="label label-' + this.canonical(name) + '" style="background-color: ' + labels[name] + ';" href="javascript:github_dashboard.filter(\'label\', \'' + name + '\');">' + name + '</a>');
				this.labelVisible[name] = true;
			}
		}
	},
	
	canonical: function(raw) {
		return raw.replace(/[^a-zA-Z0-9_\-]+/, '-');
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
	}
};