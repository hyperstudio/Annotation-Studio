class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index
    @collection = Collection.find(params[:collection_id])
    @documents = @collection.documents

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @collection = Collection.find(params[:collection_id])
    @document = @collection.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @collection = Collection.find(params[:collection_id])
    @document = @collection.document.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @collection = Collection.find(params[:collection_id])
    @document = @collection.documents.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @collection = Collection.find(params[:collection_id])
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

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @collection = Collection.find(params[:collection_id])
    @document = @collection.documents.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
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
    @collection = Collection.find(params[:collection_id])
    @document = @collection.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
