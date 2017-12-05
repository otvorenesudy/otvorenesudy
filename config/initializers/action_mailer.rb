unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.mailgun.org',
    domain: 'mg.otvorenesudy.sk',
    port: 587,
    user_name: Configuration.mailer.username,
    password: Configuration.mailer.password
  }
end
