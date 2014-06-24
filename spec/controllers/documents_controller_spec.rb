require 'spec_helper'

describe DocumentsController do
  context '#create' do
    it 'enqueues DocumentProcessor jobs correctly when documents are uploaded' do
      sign_in_user
      document = build_document

      document_processor_double = double(perform: -> {} )

      DocumentProcessor.should_receive(:new).with(
        document.id,
        document.state,
        Apartment::Database.current_tenant
      ).and_return(document_processor_double)

      post :create, { document: { upload: true }}
    end
  end

  def sign_in_user
    user = create(:user)
    user.stub(:has_role?).and_return(true)
    sign_in user
  end

  def build_document
    document = build(:document, id: 1, state: 'published')
    Document.stub(:new).and_return(document)
    Document.stub(:save).and_return(true)
    document
  end
end
