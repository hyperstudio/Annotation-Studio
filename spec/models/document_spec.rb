require 'spec_helper'

describe Document do
  context 'file uploads' do
    it { should validate_attachment_content_type(:upload).allowing(
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain',
      'application/pdf'
      )}

    it 'interpolates the tenant name into the path' do
      Apartment::Database.switch('www')
      
      document = build(:document)
      document.upload = File.open(example_file('example.html'))

      expect(document.upload.path).to match '/www/'
      Apartment::Database.switch('public')
    end
  end

  context '#processed?' do
    it { subject.should_not be_processed }

    it "is true when processed_at? is set" do
      document = build(:document, processed_at: DateTime.now)
      expect(document).to be_processed
    end
  end
end
