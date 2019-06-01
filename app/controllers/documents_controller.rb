require 'json'

class DocumentsController < ApplicationController
  before_filter :find_document, :only => [:show, :set_default_state, :preview, :annotatable, :review, :publish, :export, :archive, :snapshot, :destroy, :edit, :update]
  before_filter :authenticate_user!

  load_and_authorize_resource :except => :create

  # GET /documents
  # GET /documents.json
  def index

    if params[:docs] != 'assigned' && params[:docs] != 'created' && params[:docs] != 'all'
      document_set = 'assigned'
    else
      document_set = params[:docs]
    end

    @tab_state = { document_set => 'active' }
    @assigned_documents_count = Document.active.tagged_with(current_user.rep_group_list, :any =>true).count
    @created_documents_count = current_user.documents.count
    @all_documents_count = Document.all.count

    per_page = 20

    if document_set == 'assigned'
      @documents = Document.active.tagged_with(current_user.rep_group_list, :any =>true).paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
    elsif document_set == 'created'
      @documents = current_user.documents.paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
    elsif can? :manage, Document && document_set == 'all'
      @documents = Document.paginate(:page => params[:page], :per_page => per_page ).order("created_at DESC")
    end

    if params[:group]
      @documents = @documents.tagged_with(params[:group]).paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
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
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(documents_params)
    @document.user = current_user

    respond_to do |format|
      if @document.save
        if params[:document][:upload].present?
          Delayed::Job.enqueue DocumentProcessor.new(@document.id, @document.state, Apartment::Tenant.current_tenant)
          @document.pending!
        end
        format.html { redirect_to documents_url, notice: 'Document was successfully created.', anchor: 'created'}
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.friendly.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(documents_params)
        format.html { redirect_to documents_url, notice: 'Document was successfully updated.' }
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
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
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

  def annotatable

    respond_to do |format|
      if @document.update_attribute(:state, 'annotatable')
        format.html { redirect_to documents_url, notice: 'Document is now annotatable.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def review

    respond_to do |format|
      if @document.update_attribute(:state, 'review')
        format.html { redirect_to documents_url, notice: 'Document is now reviewable.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def publish
    respond_to do |format|
      if @document.update_attribute(:state, 'published')
        format.html { redirect_to documents_url, notice: 'Document is now publishable.', anchor: 'created'}
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

    before_filter :prepare_for_mobile

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
                                     :publication_date, :source, :rights_status, :upload, :survey_link)
  end
end
