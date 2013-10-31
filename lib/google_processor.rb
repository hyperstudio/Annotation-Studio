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

    @document.text = File.read(converted_copy.path)
    @document.processed_at = DateTime.now
    @document.save
  end

	private 

	def create_session
		GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASS'])
	end
end
