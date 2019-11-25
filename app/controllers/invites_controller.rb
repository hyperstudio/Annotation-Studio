class InvitesController < ApplicationController
	def create
		@invite = Invite.new(invite_params) #make new invite

		#set to 1 month for now. 
		@invite.expiration_date = Time.now + 1.month

		respond_to do |format|
			if @invite.save
				format.html { redirect_to request.referrer, notice: 'Invite Link Generated' }
			else
				format.html { redirect_to request.referrer, notice: 'Error Creating Invite Link'}
			end

		end

	end

	private
	def invite_params
		params.require(:invite).permit(:group_id, :token, :created_at, :updated_at, :expiration_date)
	end
end
