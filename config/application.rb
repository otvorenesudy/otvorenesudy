require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module OpenCourts
  class Application < Rails::Application
    config.load_defaults 8.0
    config.time_zone = 'Bratislava'
    config.i18n.default_locale = :sk
    config.i18n.locale = :sk
    config.i18n.available_locales = %i[sk en]
    config.i18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.exceptions_app = routes
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_job.queue_adapter = :solid_queue
    config.cache_store = :solid_cache_store
    config.active_record.schema_format = :sql
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
  end
end
