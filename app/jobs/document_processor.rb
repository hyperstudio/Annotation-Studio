class DocumentProcessor
  attr_reader :document_id

  def initialize(document_id, document_state, tenant)
    @document_id = document_id
    @document_state = document_state
    @tenant = tenant
  end

  def perform
    original_tenant = Apartment::Tenant.current_tenant
    begin
      Apartment::Tenant.switch(@tenant)
      document = Document.find(@document_id)

      processor_class = DocumentProcessorDispatcher.processor_for(document.upload.content_type)
      processor = processor_class.new(document, @document_state)

      processor.work
    ensure
      Apartment::Tenant.switch(original_tenant)
    end
  end
end
