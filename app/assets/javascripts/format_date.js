window.formatDateTime = function(date) {
	"use strict";

	function pad(number) {
		if (number < 10)
			return "0" + number;
		return '' + number;
	}
	date = new Date(Date.parse(date));
	var day = date.getDate();
	var month = date.getMonth() + 1;
	var year = date.getFullYear();
	var hour = date.getHours() + 1;
	var minute = date.getMinutes() + 1;

	return pad(month) + '/' + pad(day) + '/' + year + ' ' + pad(hour) + ':' + pad(minute);
};


