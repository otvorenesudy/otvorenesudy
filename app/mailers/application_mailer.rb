# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Otvorené súdy <noreply@otvorenesudy.sk>'

  layout 'mailer'
end
