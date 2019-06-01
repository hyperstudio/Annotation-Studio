require 'spec_helper'

describe DocumentProcessor do
  it "should instantiate a document when performing" do
    document = build(:document, id: 100)
    Document.should_receive(:find).with(document.id).and_return(document)

    job = described_class.new(document.id, 'a state', 'www')
    job.perform
  end

  it "should use the DocumentProcessorDispatcher to find which processor to use" do
    document = build(:document, id: 100, upload: example_file('example.docx'))
    Document.stub(:find).with(document.id).and_return(document)

    DocumentProcessorDispatcher.should_receive(:processor_for).
      with(document.upload.content_type).
      and_return(NullProcessor)

    job = described_class.new(document.id, 'a state', 'www')
    job.perform
  end

  context 'apartment multitenancy' do
    it 'switches tenants when running a job' do
      Apartment::Tenant.switch('public')
      current_tenant = Apartment::Tenant.current_tenant
      document = build(:document, id: 100)
      Document.should_receive(:find).with(document.id).and_return(document)

      Apartment::Tenant.should_receive(:switch).with('www')
      Apartment::Tenant.should_receive(:switch).with(current_tenant)

      job = described_class.new(document.id, 'a state', 'www')
      job.perform
    end
  end
end
