$(function () {
	"use strict";

	var body = $("body");

	body.on('click', '.show-password-fields', function(e) {
		var el = $(this);
		var passwordFields = '<label for="user_current_password">Current Password</label>\n<input class="form-control" id="user_current_password" name="user[current_password]" size="30" type="password">';
		passwordFields += '<label for="user_password">New Password</label>\n<input class="form-control" id="user_password" name="user[password]" size="30" type="password">';
		passwordFields += '<label for="user_password_confirmation">Confirm Password</label>\n<input class="form-control" id="user_password_confirmation" name="user[password_confirmation]" size="30" type="password">';
		passwordFields += "<button class=\"cancel-password-fields btn btn-default\">Cancel Change Password</button>";
		el.closest(".form-group").html(passwordFields);
		return false;
	});

	body.on('click', '.cancel-password-fields', function(e) {
		var el = $(this);
		var passwordFields = '<button class="show-password-fields btn btn-default">Change Password</button>';
		el.closest(".form-group").html(passwordFields);
		return false;
	});
});
