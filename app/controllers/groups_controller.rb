class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find(params[:id])
    @memberships = @group.memberships
    @documents = @group.documents
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render xml: @group }
    end
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      @group.users << current_user

      #set role to owner
      Membership.find_by(group_id: @group.id, user_id: current_user.id).update_attribute("role", "owner")

      flash[:success] = "Created Group " + @group.name + " successfully!"
      redirect_to edit_group_path(id: @group.id)
    else
      flash[:alert] = "Error in creating group."
      redirect_to request.referrer
    end
  end

  def edit
    @group = Group.find(params[:id])
    if params["search"] #group member search
      queryStr = "%" + params["search"].downcase + "%"
      matches = User.where(["lower(users.firstname) LIKE ?", queryStr]).pluck(:id)
      @memberships = Membership.includes(:user).where(group_id: params[:id], user_id: matches)
    else
      @memberships = @group.memberships
    end

    @ISstatus = @group.ideaSpaceOn ? "Enabled" : "Disabled" #whether Idea space is enabled or disabled
    @IStoggle = @group.ideaSpaceOn ? "Disable" : "Enable" #toggle button
  end

  def update
    @group_id = params["id"]
    @group = Group.find(@group_id)

    if params["email"]
      new_email = params["email"]
      user = User.find_by(email: new_email)
      if user && (!user.groups.include? @group)
        @group.users << user
        flash[:success] = user.fullname + " added."
        # InviteMailer.notify_existing_user(user, @group).deliver_now
      else
        flash[:alert] = "User not found or already in group."
      end
    end
    if params["name"] && params["commit"] == "Save"
      if params["name"] == ""
        flash[:alert] = "Group name cannot be blank."
      else
        @group.name = params["name"]
        if @group.save
          flash[:success] = "Group name changed to \"" + params["name"] + "\" successfully."
        else
          flash[:alert] = "Error changing Group name."
        end
      end
    end
    redirect_to request.referrer
  end

  def destroy
    @group_id = params["id"]
    @group = Group.find(@group_id)
    if @group.destroy
      flash[:success] = "Group " + @group.name.to_s + " was deleted."
    else
      flash[:alert] = "Error deleting group " + @group.name.to_s + "."
    end
    redirect_to groups_path
  end



  def update_member_role
    @membership = Membership.find(params[:m_id])
    if @membership.update_attribute("role", params[:role])
      flash[:success] = "Changed  " + params[:username] + "'s role to " + params[:role]
    else
      flash[:alert] = "Error changing " + params[:username] + "'s role to " + params[:role]
    end

    redirect_to edit_group_path(id: params[:group_id])
  end

  def leave
    @gid = params[:id]
    @uid = current_user.id
    @membership = Membership.find_by(user_id: @uid, group_id: @gid)

    if @membership
      @membership.destroy
      flash[:success] = "Left " + Group.find(@gid).name.to_s
    else
      flash[:alert] = "Error leaving group"
    end

    respond_to do |format|
      format.html { redirect_to dashboard_path(nav: "mygroups") }
      format.xml { head :no_content }
    end
  end

  def remove_member
    @membership = Membership.find(params[:m_id])
    if @membership
      @membership.destroy
      flash[:success] = "Removed " + params[:username]
    else
      flash[:alert] = "Error removing member"
    end

    redirect_to request.referrer
  end

  def toggleIS
    thisGroup = Group.find(params[:group_id])
    if params[:ideaSpace] == "change"
      current = thisGroup.ideaSpaceOn
      state = !current ? "on" : "off"
      if thisGroup.update_attribute("ideaSpaceOn", !current) #toggle between true and false
        flash[:success] = "Turned Idea Space " + state
      else
        flash[:alert] = "Error turning Idea Space " + state
      end
      redirect_to edit_group_path(id: params[:group_id])
    end
  end

  def bad_permissions
    flash[:alert] = "You do not have permission to manage " + @group.name.to_s + "."
    redirect_to groups_path
  end
  helper_method :bad_permissions

  private

  def group_params
    params.require(:group).permit(:name, :owner_id)
  end
end
