class UserSetsController < ApplicationController
  load_and_authorize_resource        # CanCan

  def index
    @users = UserSet.new
  end

  def edit
    @user = User.find(params[:id])
  end

  # Right now this handles a set of users, not one individually.
  # It may make sense to break out the user_set to have its own
  # controller, but right now that is overkill.
  def update
    @users = UserSet.new
    @users.users_attributes(params[:users])

    if @users.save
      flash[:notice] = 'Users were successfully updated.'
      render :index
      # WHY does redirecting revert the models to their previous state?
      # redirect_to user_sets_path
    else
      flash[:notice] = 'Users were not successfully updated.'
      redirect_to user_sets_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to user_sets_path
  end
end
