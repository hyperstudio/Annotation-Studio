(function ($) {
	"use strict";

	// hide all divs that contain the class "self_removing" after a time period.
	setTimeout(function() {
		var el = $(".self_removing");
		el.alert('close');
	}, 5000);
})(window.jQuery);
