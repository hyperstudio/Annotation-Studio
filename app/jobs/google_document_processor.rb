class GoogleDocumentProcessor 
  attr_reader :document_id

  def initialize(document_id)
    @document_id = document_id
  end

  def perform
    document = Document.find(@document_id)

  end
end
