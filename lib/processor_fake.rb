class ProcessorFake
  def initialize(document, document_state)
    @document = document
    @original_state = document_state
  end

  def work
    @document.processed_at = DateTime.now
    @document.text = '<p>foo</p>'
    @document.state = @original_state
    @document.save
  end

end
