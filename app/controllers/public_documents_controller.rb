class PublicDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show, :index]

  def show
    @now = DateTime.current().to_time.iso8601
    session['guest_jwt'] = JWT.encode(
        {
            'consumerKey' => ENV["API_CONSUMER"],
            'userId' => "guest@example.com",
            'issuedAt' => @now,
            'ttl' => 86400
        },
        ENV["API_SECRET"]
    )

    @document = Document.publicly.friendly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  before_action :prepare_for_mobile

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
  end

end
