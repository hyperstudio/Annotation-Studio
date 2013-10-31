require 'rake'
require 'google_processor'

namespace :annotationstudio do
  desc 'test google drive API html conversion'
  task drive_conversion_test: :environment do

    document = Document.create(
      title: 'I am a test', author: 'Test Author',
      upload: File.open('spec/support/example_files/annotation-studio-white-paper.docx'),
      user_id: 2,
      rep_group_list: "public",
    )


    processor = GoogleProcessor.new(document)
    processor.work

    document.reload

    #binding.pry

  end
end
