require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups(:assets => %w(development test)))

module AnnotationStudio
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # config.middleware.use Rack::Deflator
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_record.raise_in_transactional_callbacks = true
  end
end
