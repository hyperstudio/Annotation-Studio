class InvitesController < ApplicationController
	def create
		@invite = Invite.new(invite_params) #make new invite

		#set to 1 month for now. 
		@invite.expiration_date = Time.now + 1.month

		respond_to do |format|
			if @invite.save
				format.html { redirect_to edit_group_path(:id=>invite_params[:group_id], :destroy_invite => "false"), notice: 'Invite link generated.' }
			else
				format.html { redirect_to request.referrer, notice: 'Error creating invite link.'}
			end

		end

	end

	private
	def invite_params
		params.require(:invite).permit(:group_id, :token, :created_at, :updated_at, :expiration_date)
	end
end
