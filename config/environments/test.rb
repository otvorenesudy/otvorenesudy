require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = true
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.raise_on_open_redirects = true

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.migration_error = :page_load
  config.active_record.maintain_test_schema = true

  config.i18n.raise_on_missing_translations = true
end
