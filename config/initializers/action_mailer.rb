unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    domain: 'otvorenesudy.sk',
    port: 587,
    user_name: Configuration.mailer.username,
    password: Configuration.mailer.password,
    authentication: :plain,
    enable_starttls_auto: true
  }
end
