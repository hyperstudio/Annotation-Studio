class DocumentProcessor < ApplicationJob
  attr_reader :document_id

  around_perform :around_process

  def perform(document_id, document_state, tenant)
    Apartment::Tenant.switch!(tenant)
    document = Document.find(document_id)

    processor_class = DocumentProcessorDispatcher.processor_for(document.upload.content_type)
    processor = processor_class.new(document, document_state)

    processor.work
  end

  private

  def around_process
    original_tenant = Apartment::Tenant.current
    yield
    Apartment::Tenant.switch!(original_tenant)
  end
end
