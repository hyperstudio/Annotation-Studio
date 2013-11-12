require 'spec_helper'
require 'processor_fake'

describe ProcessorFake do

  it "should set processed_at on a document" do
    document = create_processed_document

    expect(document.processed_at).to be
  end

  it "should add content to a document" do
    document = create_processed_document

    expect(document.text).to eq '<p>foo</p>'
  end


  def create_processed_document
    upload_file = File.open('spec/support/example_files/example.docx')
    document = create(:document, upload: upload_file, text: nil)

    process = ProcessorFake.new(document)
    process.work
    document.reload
    document
  end
end
