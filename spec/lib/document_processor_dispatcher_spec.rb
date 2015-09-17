require 'spec_helper'

describe DocumentProcessorDispatcher do
  context 'when a fake is configured' do
    it 'returns the fake' do
      with_real_document_processors(false) do
        expect(described_class.processor_for('blarg')).to eq ProcessorFake
      end
    end
  end

  context '.processor_for' do
    it 'returns YomuProcessor for .doc and .docx mime-types' do
      with_real_document_processors do
        %w(
application/msword
application/vnd.openxmlformats-officedocument.wordprocessingml.document
        ).each do |mime_type|

          expect(described_class.processor_for(mime_type)).to eq YomuProcessor
        end
      end
    end

    it 'returns PdfProcessor for pdf mime-types' do
      with_real_document_processors do
        expect(described_class.processor_for('application/pdf')).to eq \
          PdfProcessor
      end
    end

    it 'returns NullProcessor for unknown mime-types' do
      with_real_document_processors do
        expect(described_class.processor_for('your/momma')).to eq NullProcessor
      end
    end
  end

  def with_real_document_processors( use_real=true )
    default_setting = Rails.application.config.use_fake_document_processor
    begin
      Rails.application.config.use_fake_document_processor = (not use_real)
      yield
    ensure
      Rails.application.config.use_fake_document_processor = default_setting
    end
  end
  
end
