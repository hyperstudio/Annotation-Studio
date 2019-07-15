class InvitesController < ApplicationController
	def create
		@invite = Invite.new(invite_params) #make new invite

		#for production, change expiration_date to something more reasonable, 
		#like a month, or one semester. 
		@invite.expiration_date = Time.now + 5.minute

		if @invite.save
			redirect_to request.referrer
		end

	end

	def join_via_token
		@token = params['token']
		puts 'token found'
		#make sure token is valid 
		begin
			invite = Invite.find_by(token: @token)
			#check for expiration 
			if invite.expiration_date && (invite.expiration_date < Time.now)
				flash[:error] = 'token expired. please get new token'
				redirect_to dashboard_path
				return
			end

			org =  invite.group #find the user group attached to the invite
			current_user.groups << org #add this user to the new user group as a member
			flash[:alert] = 'Successfully joined group!'

		rescue ActiveRecord::RecordNotUnique
			flash[:error] = 'already in group'

		rescue NoMethodError #if token is invalid, org will call .group on a nil class which returns this error
			flash[:error] = 'invalid token'
			
		end
		redirect_to dashboard_path
		
	end


	private
	def invite_params
		params.require(:invite).permit(:group_id, :token, :created_at, :updated_at, :expiration_date)
	end
end
