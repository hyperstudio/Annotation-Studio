require 'json'

class DocumentsController < ApplicationController
  before_action :find_document, :only => [:show, :set_default_state, :preview, :archive, :publicize, :publish, :export, :snapshot, :destroy, :edit, :update]
  before_action :authenticate_user!

  load_and_authorize_resource :except => :create

  # GET /documents
  # GET /documents.json
  def index #search results

      shared = helpers.getSharedDocs() #see application_helper.rb
      mine = current_user.documents

      #this might cause problems when shared docs get REALLY BIG
      all = shared | mine #array

    if params['search'] && params['search'] != ""
      case params['method']
        when "title"
          # @documents = Document.where(["title LIKE ?", "%#{params['search']}%"])
          @documents = all.select {|d| d.title.include? params['search']}
          @title_text = "Title: '#{params['search']}'"
        when "author"
          # @documents = Document.where(["author LIKE ?", "%#{params['search']}%"])
          @documents = all.select {|d| d.author.include? params['search']}
          @title_text = "Author: '#{params['search']}'"
        when "status"
          # @documents = Document.where(["state LIKE ?", "%#{params['search']}%"])
          @documents = all.select {|d| d.state.include? params['search']}
          @title_text = "Status: '#{params['search']}'"
        when "group"
          group = Group.find_by(name: params['search'])
          @documents = group ? group.documents : []
          @title_text = "Group: '#{params['search']}'"
      end #end case
    end #end if

    
  end #end index


  def old_index #index of the old version. 
    whitelisted = params.permit(:docs, :page, :group)
    if !%w[ assigned created all ].include?(whitelisted[:docs])
      document_set = 'assigned'
    else
      document_set = whitelisted[:docs]
    end

    @tab_state = { document_set => 'active' }
    @assigned_documents_count = (Document.active.tagged_with(current_user.rep_group_list, :any =>true)).where.not(state: 'draft').count
    @created_documents_count = current_user.documents.count
    @all_documents_count = Document.all.count

    per_page = 20


    if document_set == 'assigned'
      #@documents = Document.active.tagged_with(current_user.rep_group_list, :any =>true).where.not(state: 'draft').paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')

      #use an array instead of activeRecordAssociation
      #problem: can't sort documents by creation date
      #also need to loop through each individual group's docs in order to return document objects

      docList = []
      current_user.groups.each do |g| 
        g.documents.where.not(state: 'draft').each do |d|
          unless docList.include? d 
            docList << d
          end
        end
      end

      @documents = docList.paginate(:page => whitelisted[:page], :per_page => per_page)
     
      

    elsif document_set == 'created'
      @documents = current_user.documents.paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')
    elsif can? :manage, Document && document_set == 'all'
      @documents = Document.paginate(:page => whitelisted[:page], :per_page => per_page ).order("created_at DESC")
    end

    if whitelisted[:group]
      @documents = @documents.tagged_with(whitelisted[:group]).where.not(state: 'draft').paginate(:page => whitelisted[:page], :per_page => per_page).order('created_at DESC')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    if request.path != document_path(@document)
      redirect_to @document, status: :moved_permanently
    end

    # configuration for annotator
    @annotation_categories_enabled =  Tenant.annotation_categories_enabled
    @enable_rich_text_editor = ENV["ANNOTATOR_RICHTEXT"]
    @tiny_mce_toolbar = ENV["ANNOTATOR_RICHTEXT_CONFIG"]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/preview
  def preview
    respond_to do |format|
      format.html # preview.html.erb
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
     #display current groups on tags input line. 
    @current_groups = @document.groups.pluck(:name).join(",")
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(documents_params)
    @document.user = current_user

    if params["type"]
      @document.update_attribute(:resource_type, params["type"])
    end

  
  #attach document to groups
    @groups = params["groups"] if params["groups"]
    # puts "groups"
    # puts @groups
    @groupList = @groups.split(",")
    if @groups
      @groupList.each do |g|
        @document.groups << Group.find_by(name: g) if Group.find_by(name: g)
      end
    end


    respond_to do |format|
      if @document.save
        if params[:document][:upload].present?
          Delayed::Job.enqueue DocumentProcessor.new(@document.id, @document.state, Apartment::Tenant.current)
          @document.pending!
        end

        format.html { redirect_to dashboard_path(nav: "mydocuments"), notice: 'Document was successfully created.', anchor: 'created'}
        format.json { render json: @document, status: :created, location: @document }
      else
         flash[:alert] = @document.errors.full_messages.join(", ")
        # format.html { redirect_to request.referrer }

        #render action: :new keeps on creating new documents, even with the validation. 
        format.html {render action: "new"}
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.friendly.find(params[:id])
    #attach document to groups
    @groups = params["groups"].split(",") if params["groups"]
    @oldGroups = @document.groups.pluck(:name)


    #need to loop through oldGroups to find difference!!! 
    if @groups

      @groups.each do |g|
        unless @oldGroups.include? g #don't re-insert existing groups
          @document.groups << Group.find_by(name: g)
        end #unless 
      end #each

      #delete group from documents
      diff = @oldGroups - @groups
      if !diff.empty?
        diff.each do |d|
          @document.groups.delete(Group.find_by(name: d))
        end #each
      end #if diff.empty?
      
    end #if 
    
    @document.update_attribute("updated_at", Time.now)

  

    respond_to do |format|
      if @document.update_attributes(documents_params)
        format.html { redirect_to dashboard_path(nav: "mydocuments"), notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    flash[:alert] = @document.title + " deleted"
    @document.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_path(nav: "mydocuments") }
      format.json { head :no_content }
    end
  end

  #JSON for saving state
  def set_default_state
    @document.update_attribute(:default_state, params[:default_state])

    render :json => {}
  rescue Exception => e
    render :json => {}
  end

  def archive
    respond_to do |format|
      if @document.update_attribute(:state, 'archived')
        format.html { redirect_to documents_url, notice: 'Document was successfully archived.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def publish
    respond_to do |format|
      if @document.update_attribute(:state, 'published')
        format.html { redirect_to documents_url, notice: 'Document is now published.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def publicize
    respond_to do |format|
      if @document.update_attribute(:state, 'public')
        format.html { redirect_to documents_url, notice: 'Document is now public.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end
  #Export HTML
  def export
    send_data(@document.snapshot, filename: "#{@document.title}.html")
  end

  #Snapshot of document for export
  def snapshot
    @document.update_attribute(:snapshot, params[:snapshot])
    render :json => {}
  rescue Exception => e
    render :json => {}
  end


  # Helper which accepts an array of items and filters out those you are not allowed to read, according to CanCan abilities.
  # From Miximize.
  def filter_by_can_read(items)
    items.collect do |i|
      i unless cannot? :read, i
    end
  end

  def filter_by_samegroup(items)
    items.collect do |i|
      i unless cannot? :read, i
    end
  end

    before_action :prepare_for_mobile

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
  end

private
  def find_document
    @document = Document.friendly.find(params.has_key?(:document_id) ? params[:document_id] : params[:id])
  end

  def documents_params
    params.require(:document).permit(:title, :state, :chapters, :text, :snapshot, :user_id, :rep_privacy_list,
                                     :rep_group_list, :new_group, :author, :edition, :publisher,
                                     :publication_date, :source, :rights_status, :upload, :survey_link, :location, 
                                     :page_numbers, :series, :journal_title, :notes, :resource_type, groups: :group_id)
  end
end

