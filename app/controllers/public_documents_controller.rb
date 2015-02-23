class PublicDocumentsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show, :index]

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

    @document = Document.public.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
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

end
