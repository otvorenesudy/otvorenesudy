require File.expand_path('../boot', __FILE__)
require File.expand_path('../version', __FILE__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w[development test]))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

# Fix PostgreSQL@16 compatibility
require 'active_record/connection_adapters/postgresql_adapter'
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def set_standard_conforming_strings
    old, self.client_min_messages = client_min_messages, 'warning'
    begin
      execute('SET standard_conforming_strings = on', 'SCHEMA')
    rescue StandardError
      nil
    end
  ensure
    self.client_min_messages = old
  end
end

module OpenCourts
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Sets exceptions application routing, allows custom error handling.
    config.exceptions_app = self.routes

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # TODO remove concerns path after upgrading to Rails 4
    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/controllers/concerns
      #{config.root}/app/models/concerns
    ]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bratislava'

    # Set default locale
    config.i18n.default_locale = :sk
    config.i18n.locale = :sk

    # Set available locales and enforce them
    config.i18n.available_locales = %i[sk en]
    config.i18n.enforce_available_locales = true

    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join 'config', 'locales', '**', '*.{rb,yml}']

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '4.0'
  end
end
