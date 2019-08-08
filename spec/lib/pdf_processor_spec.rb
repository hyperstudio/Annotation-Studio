require 'spec_helper'

describe PdfProcessor do
  it 'processes pdf' do
    document = create(:document, upload: example_file('example.pdf'))

    processor = described_class.new(document, 'published')
    processor.work

    expect(document.text).to match 'Alice'
  end
end
