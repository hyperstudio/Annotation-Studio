class DocumentsController < ApplicationController

  before_filter :authenticate
  before_filter :get_collection

  # GET /collection/1/documents
  # GET /collection/1/documents.json
  def index
    @documents = @collection.documents

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /collection/1/documents/1
  # GET /collection/1/documents/1.json
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /collection/1/documents/new
  # GET /collection/1/documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /collection/1/documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /collection/1/documents
  # POST /collection/1/documents.json
  def create
    @document = @collection.documents.build(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to @collection, notice: 'Document was successfully created.' }
        format.json { render json: @collection, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collection/1/documents/1
  # PUT /collection/1/documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @collection, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection/1/documents/1
  # DELETE /collection/1/documents/1.json
  def destroy
    @document = @collection.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to @collection }
      format.json { head :no_content }
    end
  end
  
  def get_collection
  	@collection = Collection.find(params[:collection_id])
  end
end
