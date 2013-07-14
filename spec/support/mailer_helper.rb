module MailerHelper
  def self.last_email
    ActionMailer::Base.deliveries.last
  end

  def self.reset_email
    ActionMailer::Base.deliveries = []
  end
end
