# frozen_string_literal: true

Devise.setup do |config|
  # The key from the Rails 3 app, so confirmation and password reset links sent before the upgrade keep working.
  # Without it Devise signs its tokens with secret_key_base.
  config.secret_key = Rails.application.credentials.dig(:devise, :key)

  config.mailer_sender = 'noreply@otvorenesudy.sk'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]

  # Production hashes are bcrypt with cost 10; keep it so existing passwords and new ones cost the same.
  config.stretches = Rails.env.test? ? 1 : 10

  config.allow_unconfirmed_access_for = 2.days
  config.reconfirmable = true

  config.remember_for = 2.weeks
  config.extend_remember_period = true
  config.expire_all_remember_me_on_sign_out = true
  config.rememberable_options = { secure: true }

  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 8.hours

  config.sign_out_via = :delete

  # Turbo needs a 422 for failed forms and a 303 after a successful one.
  config.responder.error_status = :unprocessable_content
  config.responder.redirect_status = :see_other
end
