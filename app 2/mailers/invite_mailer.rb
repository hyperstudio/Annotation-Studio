class InviteMailer < ApplicationMailer
	def notify_existing_user(user, group)
		@user = user
		@group = group
		mail(to: @user.email, subject: 'You were added to a group')
	end

end

