class RegistrationsController < Devise::RegistrationsController
	prepend_before_action :require_no_authentication, only: [:create, :cancel]

	#not sure if necessary
	def new
		@invitetoken = params[:invite_token]
    if @invitetoken 

      #make sure token is valid 
      begin
        invite = Invite.find_by(token: @invitetoken)
        
        #check for expiration 
        unless invite.expiration_date && (invite.expiration_date < Time.now)
          org =  invite.group #find the user group attached to the invite
          current_user.groups << org #add this user to the new user group as a member
          flash[:alert] = 'Successfully joined group!'

        else
          flash[:error] = 'Token expired. please get new token'
          redirect_to dashboard_path
          return

        end #end unless

      rescue ActiveRecord::RecordNotUnique
        flash[:error] = 'Already in group'

      rescue NoMethodError #if token is invalid, org will call .group on a nil class which returns this error
        flash[:error] = 'Invalid token'
        
      end #end begin-rescue
			redirect_to dashboard_path
		else
			 super
		end
	end

	def create 
		super
		if params[:invite_token] && resource.save
			@invitetoken = params[:invite_token]
			begin
				@group = Invite.find_by(token: @invitetoken).group

			rescue NoMethodError
				flash[:error] = 'Invalid token. unable to join group'
				return #early return
			end
			resource.groups << @group

			flash[:alert] = "Successfully joined group"
			
		elsif resource.save
			g = Group.find_by(name: "Public")
			if g
				resource.groups << g
			end
		end


    end 

	helper DeviseMailerUrlHelper
	protected

	def update_resource(resource, params)
		puts(params)
		if !params['password'].blank?
			resource.update_with_password(params)
		else
			params.delete("current_password")
			resource.update_without_password(params)
		end
	end
end
