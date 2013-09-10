# encoding: utf-8
class RedactorRailsPictureUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave
  include CarrierWave::MiniMagick

  # include CarrierWave::MimeTypes
  # process :set_content_type

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  process :read_dimensions

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [118, 100]
  end

  version :content do
    process :resize_to_limit => [800, 800]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    RedactorRails.image_file_types
  end
end
