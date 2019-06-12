Paperclip.interpolates :tenant do |attachment, style|
  Apartment::Database.current_tenant
end

Paperclip::Attachment.default_options[:path] = ':class/:attachment/:tenant/:id_partition/:style/:filename'

if ['production', 'staging', 'public'].include?(Rails.env)
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }
end
