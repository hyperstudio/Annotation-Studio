if ['production', 'staging', 'public'].include?(Rails.env)
  Rails.application.config.document_processor_class = GoogleProcessor
else
  Rails.application.config.document_processor_class = ProcessorFake
end
