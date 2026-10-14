# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # nginx serves /assets itself; this covers anything it passes through.
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }

  # nginx terminates TLS and redirects plain HTTP.
  config.assume_ssl = true
  config.force_ssl = true

  # Links built from the request (the canonical URL, og:image) name the host it sends, X-Forwarded-Host included;
  # other hosts get 403. The health check answers on any.
  config.hosts = %w[otvorenesudy.sk www.otvorenesudy.sk]
  config.host_authorization = { exclude: ->(request) { request.path == '/health' } }

  # Passenger sends STDOUT to its own log; the app logs to shared/log, which logrotate rotates.
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(Rails.root.join('log/production.log').to_s)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  # Memcached is shared with otvorenesudy-api and otvorenesudy-prokuratura on the server.
  config.cache_store = :mem_cache_store, 'localhost:11211', { namespace: 'otvorenesudy', compress: true }

  config.action_mailer.default_url_options = { host: 'otvorenesudy.sk', protocol: 'https' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp-relay.brevo.com',
    domain: 'otvorenesudy.sk',
    port: 587,
    user_name: Rails.application.credentials.dig(:smtp, :username),
    password: Rails.application.credentials.dig(:smtp, :password),
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]
end
