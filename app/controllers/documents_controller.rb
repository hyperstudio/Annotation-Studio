# support for MEL catalog entries
require 'melcatalog'

class DocumentsController < ApplicationController
  before_filter :find_document, :only => [:show, :set_default_state, :snapshot, :destroy, :edit, :update]
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
    @assigned_documents_count = Document.tagged_with(current_user.rep_group_list, :any =>true).count
    @created_documents_count = current_user.documents.count
    @all_documents_count = Document.all.count
    per_page = 20
    
    if document_set == 'assigned'
      @documents = Document.tagged_with(current_user.rep_group_list, :any =>true).paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
    elsif document_set == 'created'
      @documents = current_user.documents.paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
    elsif can? :manage, Document && document_set == 'all'
      @documents = Document.paginate(:page => params[:page], :per_page => per_page ).order("created_at DESC")
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

    # configuration for annotator [note that public schema won't have mel_catalog enabled]
    @mel_catalog_enabled =  Tenant.mel_catalog_enabled
    @annotation_categories_enabled =  Tenant.annotation_categories_enabled
    @enable_rich_text_editor = ENV["ANNOTATOR_RICHTEXT"]
    @tiny_mce_toolbar = @mel_catalog_enabled ? ENV["ANNOTATOR_RICHTEXT_WITH_CATALOG"] : ENV["ANNOTATOR_RICHTEXT_CONFIG"]
    @api_url = ENV["API_URL"]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    # list any catalogue texts as appropriate
    @catalog_texts = catalog_texts

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

    # apply any catalogue content as appropriate
    catalog_content(@document)

    respond_to do |format|
      if @document.save
        if params[:document][:upload].present?
          Delayed::Job.enqueue DocumentProcessor.new(@document.id, @document.state, Apartment::Database.current_tenant)
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

  def catalog_texts

    if catalogue_enabled?
       status, results = Melcatalog.texts
       return results[:text] unless results[:text].nil?
    end
    return []
  end

  def catalog_content( doc )

    if catalogue_enabled?
      # we put placeholder content in earlier and replace with the real thing now
      if doc.text.start_with?( "EID:" )
         eid = doc.text.split( ":",2 )[ 1 ]
         status, entry = Melcatalog.get( eid, 'stripxml' )
         if status == 200 && entry && entry[:text] && entry[:text][ 0 ] && entry[:text][ 0 ]['content']
           doc.text = entry[:text][ 0 ]['content']
         else
           doc.text = "Error getting document content from the catalog; status = #{status}, eid = #{eid}"
         end
      end
    end
  end

  private

  def catalog_texts

    if catalogue_enabled?
       status, results = Melcatalog.texts
       return results[:text] unless results[:text].nil?
    end
    return []
  end

  # helper to determine if we should support content from the MEL catalog
  def catalogue_enabled?
    Tenant.current_tenant.mel_catalog_enabled
  end
  
  def catalog_content( doc )

    if catalogue_enabled?
      # we put placeholder content in earlier and replace with the real thing now
      if doc.text.start_with?( "EID:" )
         eid = doc.text.split( ":",2 )[ 1 ]
         status, entry = Melcatalog.get( eid, 'stripxml' )
         if status == 200 && entry && entry[:text] && entry[:text][ 0 ] && entry[:text][ 0 ]['content']
           doc.text = entry[:text][ 0 ]['content']
         else
           doc.text = "Error getting document content from the catalog; status = #{status}, eid = #{eid}"
         end
      end
    end
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
