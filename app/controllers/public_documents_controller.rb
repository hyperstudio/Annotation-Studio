class PublicDocumentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show, :index]

  def show
    @document = Document.public.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end
end
