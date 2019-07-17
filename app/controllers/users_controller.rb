class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    if params[:id].nil? # if there is no user id in params, show current one
      @user = current_user
    else
      @user = User.where(:id => params[:id])
    end
    @document_list = Document.select(:slug, :title) # for getting document name in annotations table.

    @mygroups = Membership.where(user_id: current_user.id, role: "owner")
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

    gon.rabl template: 'app/views/users/show.rabl', as: 'user'
  end

  def edit
    @user = User.where(:id => params[:id])
  end

  def users_params
    params.require(:user).permit(:email, :password, :agreement, :affiliation, :password_confirmation,
                                 :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list,
                                 :rep_subgroup_list, :first_name_last_initial, :username)
  end
end
