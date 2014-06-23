if ['production', 'staging', 'public'].include?(Rails.env)
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
      :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
      :region                 => ENV["AWS_REGION"],
    }
    # config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_directory  = ENV["AWS_BIN_NAME"]                     # required
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    config.storage = :fog
  end
end
