require 'spec_helper'

describe Document do
  context 'file uploads' do
    it { should validate_attachment_content_type(:upload).allowing(
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain',
      'application/pdf'
      )}
  end

  context '#processed?' do
    it { subject.should_not be_processed }

    it "is true when processed_at? is set" do
      document = build(:document, processed_at: DateTime.now)
      expect(document).to be_processed
    end
  end
end
