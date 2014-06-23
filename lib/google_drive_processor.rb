require "google_drive"

class GoogleDriveProcessor

  def initialize(document, document_state)
    @document = document
    @original_state = document_state
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
    # body = complete.css("body")
    # body_contents = complete.css("body").inner_html

    @document.text = complete.css("body").inner_html
    @document.processed_at = DateTime.now
    @document.state = @original_state
    @document.save
  end

  private

  def create_session
    GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASS'])
  end
end
