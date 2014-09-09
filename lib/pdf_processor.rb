
class PdfProcessor

  def initialize(document, state)
    @document = document
    @state = state
  end

  def work
    local_copy = Tempfile.new(@document.upload_file_name)
    @document.upload.copy_to_local_file(:original, local_copy.path)

    parser = PdfParser.new(local_copy)
    # @document.text = parser.convert_to_html
    @document.text = parser.to_html

    @document.processed_at = DateTime.now

    # @document.state = @original_state
    @document.state = 'draft'

    @document.save
  end

  private

  class PdfParser
    include ActionView::Helpers::TextHelper

    def initialize(file_path)
      @pdf = PDF::Reader.new(file_path)
    end

    def pages
      @pdf.pages
    end

    def to_html
      html = @pdf.to_html.gsub(/&#9647;/, "&nbsp;")
    end

    def pages
      @pdf.pages
    end

    def text_from_pdf
      pages.map(&:text).join("\n")
    end

    def convert_to_html
      temp = text_from_pdf.gsub(/&#9647;/, "&nbsp;")
      simple_format(temp.gsub(/\n \n/, "\n\n")
    end
  end
end
