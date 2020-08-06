require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

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

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    config.assets.precompile += %w(active_admin.js active_admin.css)

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '2.0'

    config.assets.initialize_on_precompile = false

    # sanitization allowed tags
    config.action_view.sanitized_allowed_attributes = ["href", "src", "width", "height", "alt", "cite", "datetime", "title", "class", "name", "xml:lang", "abbr", "controls"]
    config.action_view.sanitized_allowed_tags = ["strong", "em", "b", "i", "p", "code", "pre", "tt", "samp", "kbd", "var", "sub", "sup", "dfn", "cite", "big", "small", "address", "hr", "br", "div", "span", "h1", "h2", "h3", "h4", "h5", "h6", "ul", "ol", "li", "dl", "dt", "dd", "abbr", "acronym", "a", "img", "blockquote", "del", "ins", "table", "tr", "td", "video"]

    # force HTTPS on all environments
    config.force_ssl = true

    # add lib to eager load paths
    config.eager_load_paths << "#{Rails.root}/lib"

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: [:get, :post, :options]
      end
    end

  end
end
