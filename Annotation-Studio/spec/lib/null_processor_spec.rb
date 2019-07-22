require 'spec_helper'

describe NullProcessor do
  it 'can be initialized with any number of arguments' do
    expect { described_class.new(1, 2 ,3, 4) }.not_to raise_error
  end

  it 'responds to #work' do
    processor = described_class.new()

    expect(processor).to respond_to(:work)
  end

  it 'logs when it is called' do
    logger_double = double('Logger stub', warn: '')
    Rails.should_receive(:logger).and_return(logger_double)

    described_class.new(1,2)
  end
end
