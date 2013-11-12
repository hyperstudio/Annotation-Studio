require "google_drive"

class GoogleProcessor

	def initialize(document)
		@document = document
	end

  def work
    local_copy = Tempfile.new(@document.upload_file_name)
    converted_copy = Tempfile.new("#{@document.upload_file_name}.html")
    uuid_name = File.basename(local_copy.path) + @document.upload_file_name

    session = create_session

    @document.upload.copy_to_local_file(:original, local_copy.path)
    session.upload_from_file(local_copy.path, uuid_name, :convert => true)

    file = session.file_by_title(uuid_name)
    file.download_to_file(converted_copy.path, :content_type => "text/html")

	unprocessed = File.read(converted_copy.path)
	complete = Nokogiri::HTML(unprocessed)
	body = complete.css("body")
	body_contents = complete.css("body").inner_html
	
	@document.text = body_contents.to_html
	@document.processed_at = DateTime.now
	@document.save
  end

	private 

	# def create_session
	# 	# GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASS'])
	# 	client = OAuth2::Client.new(
	# 		ENV['GOOGLE_CLIENT_ID'], 
	# 		ENV['GOOGLE_SECRET'],
	# 		:site => "https://accounts.google.com",
	# 		:token_url => "/o/oauth2/token",
	# 		:authorize_url => "/o/oauth2/auth"
	# 	)
	# 	auth_url = client.auth_code.authorize_url(
	# 		:redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
	# 		:scope =>
	# 			"https://docs.google.com/feeds/ " +
	# 			"https://docs.googleusercontent.com/ " +
	# 			"https://spreadsheets.google.com/feeds/"
	# 	)

	# 	# Redirect the user to auth_url and get authorization code from redirect URL.
	# 	auth_token = client.auth_code.get_token(
	# 		authorization_code, :redirect_uri => "http://localhost"
	# 	)

	# 	binding.pry

	# 	puts auth_token.token
	# 	puts auth_token.inspect

	# 	session = GoogleDrive.login_with_oauth(auth_token.token)
	# end

	def create_session
		GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASS'])
	end
end
