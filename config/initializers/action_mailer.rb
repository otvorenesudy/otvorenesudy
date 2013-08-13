unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "otvorenesudy.sk",
    :user_name            => Configuration.mailer.username,
    :password             => Configuration.mailer.password,
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
end
