class GoogleDocumentProcessor 
  attr_reader :document_id

  def initialize(document_id)
    @document_id = document_id
  end

  def perform
    document = Document.find(@document_id)

    processor_class = Rails.application.config.document_processor_class || GoogleProcessor
    processor = processor_class.new(document)

    processor.work

  end
end
