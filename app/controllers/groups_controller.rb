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
				rel.update_attribute("role", "owner")
			end

			flash[:alert] = "New Group Created!"
			redirect_to root_path
		else
			flash[:alert] = "Error creating group. Group name taken. "
			render :new
		end
	end

	def edit
		@group = Group.find(params[:id])
		@memberships = @group.memberships
	end

	def update
		@group_id = params['id']
		@group = Group.find(@group_id)

		@new_email = params['email']
		@user = User.find_by(email: @new_email)
		if @user && (!@user.groups.include? @group)
			@group.users << @user
			flash[:alert] = @user.fullname + " added."
		else
			flash[:alert] = "User not found or already in group."
		end

		redirect_to request.referrer

	end

	def join_via_name
	#add user to group if form is submitted. 
		@groupName = params['groupName']
	     if @groupName
	      puts "Join"
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
	    else 
	      puts "no join"
	    end
	    redirect_to request.referrer
	end


	#LOTS OF REPEITION BETWEEN PROMOTE AND DEMOTE: TRY TO SIMPLIFY?
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

		#also remove the invite entry in invites table
		# @invite = Invite.find_by(recipient_id: @pid)
		# if @invite
		# 	@invite.destroy
		# end
		if @membership
			@membership.destroy
			flash[:alert] = 'Left ' + Group.find(@gid).name.to_s 
		else
			flash[:alert]= "Error leaving group"
		end

		respond_to do |format|
			format.html {redirect_to request.referrer}
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



	private 

	def group_params
    	params.require(:group).permit(:name)
	end
end
