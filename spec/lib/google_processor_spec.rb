require 'spec_helper'

describe GoogleProcessor do

  pending it "creates temp files before processing" do
    session = double('session').as_null_object
    drive = GoogleDrive.stub(:login).and_return(session)
    file = Tempfile.new('foo')

    Tempfile.should_receive(:new).exactly(3).times.and_return(file)

    upload_file = File.open('spec/support/example_files/example.docx')
    document = create(:document, upload: upload_file, text: nil)

    processor = GoogleProcessor.new(document)
    processor.work
  end

end
