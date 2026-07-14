unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp-relay.brevo.com',
    domain: 'otvorenesudy.sk',
    port: 587,
    user_name: Rails.application.credentials.dig(:mailer, :user_name),
    password: Rails.application.credentials.dig(:mailer, :password),
    authentication: :plain,
    enable_starttls_auto: true
  }
end
