class InvitesController < ApplicationController
	def create
		@invite = Invite.new(invite_params) #make new invite

		#set to 1 month for now. 
		@invite.expiration_date = Time.now + 1.month

		if @invite.save
			redirect_to request.referrer
		end

	end

	private
	def invite_params
		params.require(:invite).permit(:group_id, :token, :created_at, :updated_at, :expiration_date)
	end
end
