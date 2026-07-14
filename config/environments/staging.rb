require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.assume_ssl = false
  config.force_ssl = false

  config.logger = ActiveSupport::Logger.new($stdout)
    .tap { |logger| logger.formatter = Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  config.action_controller.asset_host = ENV['ASSET_HOST'] if ENV['ASSET_HOST']

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'otvorenesudy.sk' }

  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.i18n.fallbacks = true
end
