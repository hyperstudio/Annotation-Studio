require 'spec_helper'

describe DocumentsController do
  include UserHelper

  context '#show' do
    it 'redirects to root' do
      sign_in_stubbed_user

      get :show, id: 100

      expect(response).to be_not_found
    end
  end

  context '#create' do
    it 'enqueues DocumentProcessor jobs correctly when documents are uploaded' do
      sign_in_stubbed_user
      document = build_document

      document_processor_double = double(perform: -> {} )

      DocumentProcessor.should_receive(:new).with(
        document.id,
        document.state,
        Apartment::Tenant.current
      ).and_return(document_processor_double)

      post :create, { document: { upload: true }}
    end
  end

  def sign_in_stubbed_user
    user = create(:user, agreement: true)
    user.stub(:has_role?).and_return(true)

    #This uses Devise::TestHelpers to sign in the user through a backdoor.
    #The other "sign_in_user" helper in UserHelper is for integration specs.
    sign_in user
  end

  def build_document
    document = build(:document, id: 1, state: 'published')
    Document.stub(:new).and_return(document)
    Document.stub(:save).and_return(true)
    document
  end
end
