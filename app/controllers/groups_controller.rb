class GroupsController < ApplicationController
  before_action :authenticate_user!



  def index
  	if params[:search]
  		q = "%#{params['search']}%"
  		@groups = Group.where(["LOWER(name) LIKE ?", q.downcase ])
  	else
  		@groups = current_user.groups
  	end
  	
     
  end

  def show
  	@group = Group.find(params[:id])
  	@memberships = @group.memberships
  	@documents = @group.documents
  end

  def new
		@group = Group.new

		respond_to do |format|
		    format.html # new.html.erb
		    format.xml  { render :xml => @group }
    	end
	end

	def create

		@group = Group.new(group_params)
		@group.users << current_user

		if @group.save

			#set role to owner
			Membership.find_by(group_id: @group.id, user_id: current_user.id).update_attribute("role", "owner")
			
			flash[:alert] = "New Group Created!"
			redirect_to edit_group_path(id: @group.id)
		else
			flash[:alert] = "Error in creating group. Name Taken"
			redirect_to request.referrer
		end
	end

	def edit
		@group = Group.find(params[:id])
		if params['search'] #group member search
			queryStr = "%" + params['search'].downcase + "%"
			matches = User.where(["lower(users.firstname) LIKE ?", queryStr]).pluck(:id)
			@memberships = Membership.where(group_id: params[:id], user_id: matches)
			
		else
			@memberships = @group.memberships
		end

		@ISstatus = @group.ideaSpaceOn ? 'Enabled' : 'Disabled' #whether Idea space is enabled or disabled
		@IStoggle = @group.ideaSpaceOn ? 'Disable' : 'Enable' #toggle button
	end

	def update
		@group_id = params['id']
		@group = Group.find(@group_id)

		new_email = params['email']
		user = User.find_by(email: new_email)
		if user && (!user.groups.include? @group)
			@group.users << user
			flash[:alert] = user.fullname + " added."
			InviteMailer.notify_existing_user(user, @group).deliver_now
		else
			flash[:alert] = "User not found or already in group."
		end

		redirect_to request.referrer

	end

	#post
	def join_via_name
	#add user to group if form is submitted. 
		@groupName = params['groupName']
	     if @groupName
	      begin

	          if Group.find_by(name: @groupName)
	            @group = Group.find_by(name: @groupName)
	            current_user.groups << @group

	            flash[:alert] = 'Successfully Joined Group!'

	          elsif Group.find_by(name: @groupName).nil?
	            flash[:alert] = 'Group not found!'
	          end

	      rescue ActiveRecord::RecordNotUnique
	          flash[:alert] = 'Already in Group!'
	      end
	    end
	    redirect_to request.referrer
	end

	def promote #make member a group manager/editor
		@membership = Membership.find(params[:m_id])
		@membership.update_attribute("role", "manager")
		flash[:alert] = "New Manager Added"

		redirect_to request.referrer
	end

	def demote #make group manager a member
		@membership = Membership.find(params[:m_id])
		@membership.update_attribute("role", "member")
		flash[:alert] = "Manager demoted"

		redirect_to request.referrer
	end


	def leave
		@gid = params[:id]
		@uid = current_user.id
		@membership =Membership.find_by(user_id: @uid, group_id: @gid)

		if @membership
			@membership.destroy
			flash[:alert] = 'Left ' + Group.find(@gid).name.to_s 
		else
			flash[:alert]= "Error leaving group"
		end

		respond_to do |format|
			format.html {redirect_to dashboard_path(nav: "mygroups")}
			format.xml  { head :no_content }
		end
	end

	def remove_member
		@membership = Membership.find(params[:m_id])
		if @membership
			@membership.destroy
			flash[:alert] = "Removed " + params[:username]
		else
			flash[:alert] = "Error removing member"
		end

		redirect_to request.referrer
	end

	def toggleIS
		thisGroup = Group.find(params[:group_id])
		if params[:ideaSpace] == 'change'
			current = thisGroup.ideaSpaceOn
			thisGroup.update_attribute("ideaSpaceOn", !current) #toggle between true and false
			redirect_to edit_group_path(id: params[:group_id])

		end
	end


	private 

	def group_params
    	params.require(:group).permit(:name, :owner_id)
	end
end
