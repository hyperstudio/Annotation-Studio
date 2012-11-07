class UsersController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :authenticate

  def show
    @user = User.find(params[:id])
  end

end