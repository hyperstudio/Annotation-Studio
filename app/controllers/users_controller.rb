class UsersController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :authenticate

  def show
    @user = User.find(params[:id])
    
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @user }
    # end
    
    gon.rabl "app/views/users/show.rabl", as: "blah"
  end

end