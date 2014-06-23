class GoogleDocumentProcessor
  attr_reader :document_id

  def initialize(document_id, document_state)
    @document_id = document_id
    @document_state = document_state
  end

  def perform
    document = Document.find(@document_id)

    processor_class = Rails.application.config.document_processor_class || GoogleProcessor
    processor = processor_class.new(document, @document_state)

    processor.work

  end
end
