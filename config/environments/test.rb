# frozen_string_literal: true

Rails.application.configure do
  config.enable_reloading = false

  # Eager loading on every full run proves that every class loads without a database or an index.
  config.eager_load = ENV['CI'].present? || ENV['COVERAGE'].present?

  config.public_file_server.headers = { 'cache-control' => 'public, max-age=3600' }

  config.consider_all_requests_local = true
  config.cache_store = :null_store

  # Errors raise in specs, except where a spec asks for the error page (see spec/support/error_pages.rb).
  config.action_dispatch.show_exceptions = :rescuable

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'www.example.com' }

  config.active_job.queue_adapter = :test

  config.active_support.deprecation = :raise

  config.i18n.raise_on_missing_translations = true
  config.action_controller.raise_on_missing_callback_actions = true
end
