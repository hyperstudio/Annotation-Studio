require 'spec_helper'

describe DocumentsController do

  before do
    sign_in build(:user)
  end

  context '#create' do

    it "creates a job to process an upload when one is submitted" do
      pending "Figure out devise authentication issues"
      document = build(:document, upload: uploaded_document)
      GoogleDocumentProcessor.should_receive(:new)

      post :create, document: document.attributes
    end

  end

  def uploaded_document
    StringIO.new('A document with content')
  end

end
