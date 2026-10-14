# frozen_string_literal: true

# Production's secrets come from the encrypted production credentials; the database login and other settings from the
# environment (the deploy user's ~/.env, shared with otvorenesudy-api). The Rails 3.2 app read its secrets through
# Configuration (config/configuration.yml); production doesn't boot without them, and says which are missing:
#
#   secret_key_base       was secret_token (signs sessions and cookies)
#   devise.secret_key     was devise.key; the same value keeps sent confirmation and reset links working
#   smtp.username         was mailer.username (Brevo)
#   smtp.password         was mailer.password
#   sentry.dsn            replaces rollbar.access_token
#   skylight.token        was OPENCOURTS_SKYLIGHT_AUTHENTICATION in .env
PRODUCTION_SECRETS = [
  [:secret_key_base],
  %i[devise secret_key],
  %i[smtp username],
  %i[smtp password],
  %i[sentry dsn],
  %i[skylight token]
].freeze

# SECRET_KEY_BASE_DUMMY is Rails' signal that no real secrets are there (building assets): nothing to check then.
if Rails.env.production? && !ENV['SECRET_KEY_BASE_DUMMY']
  missing = PRODUCTION_SECRETS.reject { |path| Rails.application.credentials.dig(*path).present? }

  if missing.any?
    raise "Missing production credentials: #{missing.map { |path| path.join('.') }.join(', ')}. " \
          'Add them with bin/rails credentials:edit --environment production.'
  end
end
