# support for MEL catalog entries
require 'melcatalog'

class DocumentsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  # GET /documents
  # GET /documents.json
  def index
    # @documents = filter_by_can_read(Document.all)

    # @documents = Document.all
    @documents = Document.order("title")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    if request.path != document_path(@document)
      redirect_to @document, status: :moved_permanently
    end

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
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document])
    @document.user = current_user

    # apply any catalogue content as appropriate
    catalog_content( @document )

    respond_to do |format|
      if @document.save
        if params[:document][:upload].present?
          Delayed::Job.enqueue DocumentProcessor.new(@document.id, @document.state, current_tenant)
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
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
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
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
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

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.env["HTTP_USER_AGENT"] =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
   # request.format = :mobile if mobile_device?
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
         if entry && entry[:text] && entry[:text][ 0 ] && entry[:text][ 0 ]['content']
           doc.text = entry[:text][ 0 ]['content']
         end
      end
    end
  end

  # helper to determine if we should support content from the MEL catalog
  def catalogue_enabled?
    true   # TODO: config...
  end

end
