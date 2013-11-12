class ProcessorFake
  def initialize(document)
    @document = document
  end

  def work
    @document.processed_at = DateTime.now
    @document.text = '<p>foo</p>'
    @document.save
  end

end
