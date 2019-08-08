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

    per_page = 10
    docs = helpers.getSharedDocs() #see application_helper.rb

  #AUTOCOMPLETE

    #for document search autocomplete (user's docs and shared group docs)
    shared_t = docs.pluck(:title)
    my_t = current_user.documents.pluck(:title)

    @titleSuggestions = shared_t | my_t
    @authorSuggestions = docs.pluck(:author) | current_user.documents.pluck(:author)
    @groupSuggestions = current_user.groups.pluck(:name)

  #END AUTOCOMPLETE
    @sharedDocsCount = docs.size

  #ajax 

    #GROUP SORT AJAX 
    @groupMode = params[:gPage]

    owned = current_user.groups.where(owner_id: current_user.id).paginate(:page => whitelisted[:page], :per_page => per_page)
    joined = current_user.groups.paginate(:page => whitelisted[:page], :per_page => per_page)

    filter = params[:filter]
    if filter == "timeASC"
      @joinedGroups = joined.order('created_at ASC')
      @mygroups = owned.order('created_at ASC') 
    else
      @joinedGroups = joined.order('created_at DESC')
      @mygroups = owned.order('created_at DESC') 
    end

    #DOCUMENT SORT AJAX
    @docMode = params[:dPage]
    shared = docs.paginate(:page => whitelisted[:page], :per_page => per_page)
    mine = current_user.documents.paginate(:page => whitelisted[:page], :per_page => per_page)

    case params[:dFilter]
      when "timeASC"
        @sharedDocs = shared.order('created_at ASC')
        @myDocs = mine.order('created_at ASC')

      when "A-Z"
        @sharedDocs = shared.order('title ASC')
        @myDocs = mine.order('title ASC')

      when "Z-A"
        @sharedDocs = shared.order('title DESC')
        @myDocs = mine.order('title DESC')

      else #"timeDESC" is default
        @sharedDocs = shared.order('created_at DESC')
        @myDocs = mine.order('created_at DESC')

    end #case

    #toggle ajax option for show.js.erb
    @ajaxOption = params[:dFilter] ? "document" : "group"

  #END AJAX 

    #handling invite_token. need to put here because invite_token is a param of dashboard route
    @token = params[:invite_token]
    if @token 

      #make sure token is valid 
      begin
        invite = Invite.find_by(token: @token)
        
        #check for expiration 
        unless invite.expiration_date && (invite.expiration_date < Time.now)
          org =  invite.group #find the user group attached to the invite
          current_user.groups << org #add this user to the new user group as a member
          flash[:alert] = 'Successfully joined group!'

        else
          flash[:error] = 'Token expired. please get new token'
          redirect_to dashboard_path
          return

        end #end unless

      rescue ActiveRecord::RecordNotUnique
        flash[:error] = 'Already in group'

      rescue NoMethodError #if token is invalid, org will call .group on a nil class which returns this error
        flash[:error] = 'Invalid token'
        
      end #end begin-rescue
      redirect_to dashboard_path
    end #end if 
   
    respond_to do |format|
      format.html # show.html.erb
      format.json {render json: @user}
      format.js #ajax
    end

    gon.rabl template: 'app/views/users/show.rabl', as: 'user'
  end

  def edit
    @user = User.where(:id => params[:id])
  end

  def users_params
    params.require(:user).permit(:email, :password, :agreement, :affiliation, :password_confirmation,
                                 :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list,
                                 :rep_subgroup_list, :first_name_last_initial, :username, :nav, :filter)
  end
end
