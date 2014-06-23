class DocumentProcessor
  attr_reader :document_id

  def initialize(document_id, document_state)
    @document_id = document_id
    @document_state = document_state
  end

  def perform
    document = Document.find(@document_id)

    processor_class = DocumentProcessorDispatcher.processor_for(document.upload.content_type)
    processor = processor_class.new(document, @document_state)

    processor.work
  end
end
