Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.traces_sample_rate = 0.1
  config.enabled_environments = %w[production staging]
  config.excluded_exceptions += %w[ActionController::RoutingError ActiveRecord::RecordNotFound]
end
