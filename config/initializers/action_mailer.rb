unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.zoho.com',
    port:                 465,
    user_name:            Configuration.mailer.username,
    password:             Configuration.mailer.password,
    authentication:       :login,
    ssl:                  true,
    tls:                  true,
    enable_starttls_auto: true
  }
end
