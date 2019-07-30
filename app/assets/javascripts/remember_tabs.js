// $(function () {
// 	"use strict";

// 	var body = $("body");

// 	// Tab positions are stored in localStorage in a hash where the key is "body-id:tab-group-id". The tab chosen is the value of that key.
// 	// The "tabs" object is global to the entire site, so ignore the saved tabs that we see that aren't on this page. That's normal.
// 	function initTabs() {
// 		var tabPositions = localStorage.tabs ? JSON.parse(localStorage.tabs) : {};
// 		for (var key in tabPositions) {
// 			if (tabPositions.hasOwnProperty(key)) {
// 				var arr = key.split(":");
// 				var tabRow = $('body#' + arr[0] + ' ' + '#' + arr[1]);
// 				if (tabRow.length > 0) {
// 					var tab = tabRow.find("a[href='" + tabPositions[key] + "']");
// 					if (tab.length > 0)
// 						tab.tab('show');
// 				}
// 			}
// 		}
// 	}
// 	initTabs();

// 	body.on('shown.bs.tab', 'a[data-toggle="tab"]', function(e) {
// 		var el = $(e.target);
// 		var container = el.closest("ul");
// 		var id = container.attr('id');
// 		var choice = el.attr('href');
// 		var page = body.attr('id');

// 		var key = page + ':' + id;

// 		var tabPositions = localStorage.tabs ? JSON.parse(localStorage.tabs) : {};
// 		tabPositions[key] = choice;
// 		localStorage.tabs = JSON.stringify(tabPositions);
// 	});
// });
