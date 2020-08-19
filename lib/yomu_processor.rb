class YomuProcessor
  def initialize(document, document_state)
    @document = document
    @original_state = document_state
  end

  def work
    local_copy = Tempfile.new(@document.upload_file_name)
    @document.upload.copy_to_local_file(:original, local_copy.path)

    yomu = Yomu.new(local_copy)
    complete = Nokogiri::HTML(yomu.html)
    @document.text = complete.css("body").inner_html
    @document.processed_at = DateTime.now
    pp @document.processed_at
    @document.state = @original_state
    pp @original_state
    pp @document.state
    @document.save
  end
end
