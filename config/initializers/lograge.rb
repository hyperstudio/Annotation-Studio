# config/initializers/lograge.rb

Rails.application.configure do
  config.lograge.enabled = true

  # add timestamp
  config.lograge.custom_options = lambda do |event|
    { time: Time.now }
  end
end
