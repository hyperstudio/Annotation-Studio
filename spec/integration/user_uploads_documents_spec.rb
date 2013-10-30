require 'spec_helper'

feature 'A user uploads a document' do
  include UserHelper

  context "with text only" do
    scenario "they see a page including their text" do
      user = sign_in_user

      upload_a_document do
        fill_in 'Text', with: 'Call me Ishmael'
      end

      expect(page).to have_content 'Call me Ishmael'
    end
  end

  context 'with an attached document' do
    context 'before the document is processed' do
      scenario "they see a notice about process status" do
        user = sign_in_user

        upload_a_document do
          attach_file 'Pick a file from your computer', 'spec/support/example_files/example.docx'
        end

        expect(page).to have_content 'Please wait. The document is being converted'
      end
    end

    context "after a document is processed" do
      scenario "they can annotate the document" do
        pending
      end
    end
  end

  def upload_a_document
    visit '/documents/new'
    fill_in 'Title', with: 'Moby-Dick'
    fill_in 'Author', with: 'Herman Melville'
    choose 'Draft'
    yield
    click_on 'Create Document'
  end
end
