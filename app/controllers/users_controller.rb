class UsersController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :authenticate

  def show
    if params[:id].nil? # if there is no user id in params, show current one
        @user = current_user
    else
        @user = User.find params[:id]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
    
    gon.rabl "app/views/users/show.rabl", as: "user"
  end

  def edit
    @user = User.find(params[:id])
  end
end