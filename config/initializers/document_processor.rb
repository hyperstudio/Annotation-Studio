if ['development','test'].include?(Rails.env)
  Rails.application.config.use_fake_document_processor = true
else
  Rails.application.config.use_fake_document_processor = false
end
