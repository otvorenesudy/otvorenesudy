# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  default from: 'Otvorené Súdy <noreply@otvorenesudy.sk>', css: 'mailers/layout'

  layout 'mailer'

  helper HearingsHelper
  helper DecreesHelper
  helper JudgesHelper
  helper SearchHelper
  helper TagHelper
  helper TextHelper
  helper TranslationHelper

  def results(subscription)
    @subscription = subscription

    @user    = @subscription.user
    @query   = @subscription.query
    @results = @subscription.results.first(10)

    @type   = @query.model.underscore.to_sym
    @model  = @query.model.constantize
    @params = @query.value.merge! order: :desc, sort: :created_at

    mail to: @user.email, subject: "[Otvorené Súdy] Nové súdne #{t @type, count: :other}", content_type: 'text/html'
  end
end
