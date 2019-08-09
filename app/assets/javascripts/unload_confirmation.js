$(function () {
	"use strict";
	var body = $('body');

	var confirmationMessage; // This is undefined to start with, which tells the unload function not to pop up a dialog.

	body.on('change', '.confirm-changes input,.confirm-changes select', function() {
		var form = $(this).closest('form');
		var submit = form.find('input[type=submit]');
		var submitName = submit.val();
		confirmationMessage = "You have unsaved changes on this page. You will lose them unless you stay on this page and click \"" + submitName + "\".";
	});

	body.on('submit', '.confirm-changes', function() {
		var form = $(this);
		var tagFields = form.find('.bootstrap-tagsinput input');
		if (tagFields.length > 0) {
			for (var i = 0; i < tagFields.length; i++) {
				var field = $(tagFields[i]);
				var val = field.val();
				if (val.length > 0) {
					alert("You haven't finished creating the class. Put the cursor after the word \"" + val + "\" and type the \"enter\" key to get it recognized.");
					return false;
				}
			}
		}
		confirmationMessage = undefined;
	});

	$(window).on('beforeunload', function(){
		return confirmationMessage;
	});
});
