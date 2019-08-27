$(function () {
	"use strict";

	$('.dont-overflow').on('shown.bs.dropdown', function () {
		var menu = $(this).find('.dropdown-menu');
		menu.css('height', '');
		menu.css('overflow', '');
		menu.css('width', '');
		var height = menu.height();
		var offset = menu.offset();
		offset = offset.top;
		var browserHeight = $( window ).height();
		var needsHeight = browserHeight < offset + height;
		if (needsHeight) {
			menu.css('height', (browserHeight - offset) + 'px');
			menu.css('overflow', 'auto');
			menu.css('width', '+=20');
		}
	});
});
