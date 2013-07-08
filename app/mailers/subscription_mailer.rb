# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  default from: "noreply@otvorenesudy.sk"

  layout 'mailer'

  def results(subscription)
    @subscription = subscription
    @user         = @subscription.user
    @query        = @subscription.query
    @type         = @query.model.underscore.to_sym
    @results      = @subscription.results

    mail(to: @user.email, subject: "Nové #{t @type, count: :other} pre Váš odber")
  end
end
