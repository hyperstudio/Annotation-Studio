require 'spec_helper'

describe DocumentProcessor do
  it "should instantiate a document when performing" do
    document = build(:document, id: 100)
    Document.should_receive(:find).with(document.id).and_return(document)

    job = described_class.new(document.id, 'a state')
    job.perform
  end

  it "should use the DocumentProcessorDispatcher to find which processor to use" do
    document = build(:document, id: 100, upload: example_file('example.docx'))
    Document.stub(:find).with(document.id).and_return(document)

    DocumentProcessorDispatcher.should_receive(:processor_for).
      with(document.upload.content_type).
      and_return(NullProcessor)

    job = described_class.new(document.id, 'a state')
    job.perform
  end
end
