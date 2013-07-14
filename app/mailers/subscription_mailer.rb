# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  default from: 'noreply@otvorenesudy.sk', css: 'subscription_mailer'

  layout 'mailer'

  helper TranslationHelper
  helper TextHelper
  helper TagHelper
  helper SearchHelper
  helper DecreesHelper
  helper HearingsHelper

  def results(subscription)
    @subscription = subscription

    @user    = @subscription.user
    @query   = @subscription.query
    @type    = @query.model.underscore.to_sym
    @results = @subscription.results.first(10)
    @model   = @query.model.constantize
    @params  = @query.value.merge! order: :desc, sort: :created_at

    mail(to: @user.email, subject: "[Otvorené Súdy] Nové #{t @type, count: :other} pre Váš odber", content_type: 'text/html')
  end

  private

  helper_method :search_url

  def search_url(type, params = {})
    case type
    when :decree
      search_decrees_url(params)
    when :hearing
      search_hearings_url(params)
    end
  end
end
