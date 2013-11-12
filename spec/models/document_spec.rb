require 'spec_helper'

describe Document do
  context '#processed?' do
    it { subject.should_not be_processed }
    
    it "is true when processed_at? is set" do
      document = build(:document, processed_at: DateTime.now)
      expect(document).to be_processed
    end
  end
end
