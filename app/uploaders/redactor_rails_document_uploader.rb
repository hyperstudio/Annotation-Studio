# encoding: utf-8
class RedactorRailsDocumentUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave

  # include CarrierWave::MimeTypes
  # process :set_content_type

  storage :fog

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    RedactorRails.document_file_types
  end
end
