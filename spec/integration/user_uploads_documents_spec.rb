require 'spec_helper'

feature 'A user uploads a document' do
  include UserHelper
  before :each do
    sign_in_user
  end

  context "with text only" do
    scenario "they see a page including their text" do
      upload_a_document do
        fill_in 'Text', with: 'Call me Ishmael'
      end

      expect(page).to have_content 'Call me Ishmael'
    end
  end

  context 'with an attached document' do

    scenario "they can't annotate a document and they know it before processing" do
      upload_a_document do
        attach_file 'Pick a file from your computer', 'spec/support/example_files/example.docx'
      end

      expect(page).to have_content 'Please wait. The document is being converted'
      expect(page).not_to have_annotator
    end

    scenario "they can annotate the document after processing" do
      upload_a_document do
        attach_file 'Pick a file from your computer', 'spec/support/example_files/example.docx'
      end
      process_last_document

      visit current_path

      expect(page).to have_annotator
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

  def have_annotator
    have_css('#annotation-well')
  end

  def process_last_document
    Document.last.update_attribute(:processed_at, DateTime.now)
  end
end
