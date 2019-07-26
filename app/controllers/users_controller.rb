class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    if params[:id].nil? # if there is no user id in params, show current one
      @user = current_user
    else
      @user = User.where(:id => params[:id])
    end
    @document_list = Document.select(:slug, :title) # for getting document name in annotations table.

    whitelisted = params.permit(:docs, :page, :group)
    # if !%w[ assigned created all ].include?(whitelisted[:docs])
    #   document_set = 'assigned'
    # else
    #   document_set = whitelisted[:docs]
    # end

    per_page = 10

    #get all the user's groups' documents w/o repetition
    docList = []
      current_user.groups.each do |g| 
        g.documents.where.not(state: 'draft').each do |d|
          unless docList.include? d 
            docList << d
          end
        end
      end

      #for document search autocomplete (user's docs and shared group docs)
      #slow processing: try to find more efficient algo
      shared = docList.map(&:title) 
      mine = current_user.documents.pluck(:title)
      @titleSuggestions = (shared + mine).uniq
      @authorSuggestions = (docList.map(&:author) + current_user.documents.pluck(:author)).uniq

      #group search autocomplete
      @groupSuggestions = current_user.groups.pluck(:name)

      @sharedDocsCount = docList.size
      @sharedDocs = docList.paginate(:page => whitelisted[:page], :per_page => per_page)
      @myDocs = current_user.documents.paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')

    #user's joined groups w/ pagination: 
    @joinedGroups = current_user.groups.paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')

    #groups where current user is owner w/ pagination
    @mygroups = Membership.where(user_id: current_user.id, role: "owner").paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')



    #handling invite_token
    @token = params[:invite_token]
    if @token 

      #make sure token is valid 
      begin
        invite = Invite.find_by(token: @token)
        
        #check for expiration 
        if invite.expiration_date && (invite.expiration_date < Time.now)
          flash[:error] = 'token expired. please get new token'
          redirect_to dashboard_path
          return
        end

        org =  invite.group #find the user group attached to the invite
        current_user.groups << org #add this user to the new user group as a member
        flash[:alert] = 'Successfully joined group!'

      rescue ActiveRecord::RecordNotUnique
        flash[:error] = 'already in group'

      rescue NoMethodError #if token is invalid, org will call .group on a nil class which returns this error
        flash[:error] = 'invalid token'
        
      end
      redirect_to dashboard_path
    end
    
   
    respond_to do |format|
      format.html # show.html.erb
      format.json {render json: @user}
    end

    #ajax
    # @selected = params[:method]
    #  respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: { success: "It works", option: params[:method] } }
    # end


    gon.rabl template: 'app/views/users/show.rabl', as: 'user'
  end

  def edit
    @user = User.where(:id => params[:id])
  end

  def users_params
    params.require(:user).permit(:email, :password, :agreement, :affiliation, :password_confirmation,
                                 :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list,
                                 :rep_subgroup_list, :first_name_last_initial, :username, :new)
  end
end
