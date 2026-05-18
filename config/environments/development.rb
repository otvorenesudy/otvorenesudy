require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  config.cache_store = :memory_store
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  config.assets.quiet = true
  config.i18n.raise_on_missing_translations = true
end
