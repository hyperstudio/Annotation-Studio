class DocumentProcessorDispatcher
  def self.processor_for(mime_type)
    if Rails.application.config.use_fake_document_processor == true
      return ProcessorFake
    end

    if mime_type.in?('application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
      GoogleDriveProcessor
    elsif mime_type == 'application/pdf'
      PdfProcessor
    else
      NullProcessor
    end
  end
end
