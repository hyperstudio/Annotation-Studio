class GroupsController < ApplicationController
  before_action :authenticate_user!



  def index
  end

  def show
  	@group = Group.find(params[:id])
  	@memberships = @group.memberships
  end

  def new
		@group = Group.new
		#race condition? need to double check
		respond_to do |format|
		    format.html # new.html.erb
		    format.xml  { render :xml => @group }
    	end
	end

	def create

		@group = Group.new(group_params)
		@group.users << current_user
		#set role to owner 

		if @group.save
			rel = Membership.find_by(group_id: @group.id, user_id: current_user.id)

			#consider using update_attribute instead. 
			if rel #not sure if this check is necessary. consider begin-rescue instead
				rel.role = "owner"
				rel.save
			end

			flash[:alert] = "New Group Created!"
			redirect_to root_path
		else
			render :new
		end
	end


	private 

	def group_params
    	params.require(:group).permit(:name)
	end
end
