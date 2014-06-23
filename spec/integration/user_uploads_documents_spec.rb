require 'spec_helper'

feature 'A user uploads a document' do
  include UserHelper
  before :each do
    sign_in_user
  end

  context "with text only" do
    scenario "they see a page including their content" do
      upload_a_document do
        fill_in 'Text', with: 'Call me Ishmael'
      end

      click_on 'Moby-Dick'

      expect(page).to have_content 'Call me Ishmael'
    end
  end

  context 'with an attached document' do

    scenario "they can't annotate a document and they know it before processing" do
      with_jobs_delayed(true) do
        upload_a_document do
          attach_file 'document_upload', 'spec/support/example_files/example.docx'
        end

        click_on 'Moby-Dick'

        expect(page).to have_content 'Please wait. The document is being converted'
        expect(page).not_to have_annotator
      end
    end

    scenario "they can annotate the document after processing" do
      with_jobs_delayed(false) do
        upload_a_document do
          attach_file 'Pick a file from your computer', 'spec/support/example_files/example.docx'
        end

        visit current_path
        click_on 'Moby-Dick'

        expect(page).to have_annotator
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

  def with_jobs_delayed(setting)
    run_setting = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = setting

    yield

    Delayed::Worker.delay_jobs = run_setting
  end

  def have_annotator
    have_css('#annotation-well')
  end

  def process_last_document
    Document.last.update_attribute(:processed_at, DateTime.now)
  end
end
