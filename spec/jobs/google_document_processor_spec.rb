require 'spec_helper'

describe GoogleDocumentProcessor do
  it "should instantiate a document when performing" do
    document = build(:document, id: 100)
    Document.should_receive(:find).with(document.id).and_return(document)
  
    job = described_class.new(document.id)
    job.perform
  end
end
