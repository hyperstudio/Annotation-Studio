require 'rake'
require 'google_drive_processor'

namespace :annotationstudio do
  desc 'test google drive API html conversion'
  task drive_conversion_test: :environment do

    document = Document.create(
      title: 'Today\'s Date: ' + Time.now.to_s, author: 'Test Author',
      upload: File.open('spec/support/example_files/annotation-studio-white-paper.docx'),
      user_id: 2,
      rep_group_list: "public",
    )


    processor = GoogleDriveProcessor.new(document, 'published')
    processor.work

    document.reload
  end
end
