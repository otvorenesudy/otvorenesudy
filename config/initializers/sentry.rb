# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.enabled_environments = %w[production]

  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.send_default_pii = false
  config.traces_sample_rate = Rails.application.credentials.dig(:sentry, :traces_sample_rate) || 0.1
end
