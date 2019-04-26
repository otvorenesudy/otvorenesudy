class SubscriptionMailer < ActionMailer::Base
  default content_type: 'text/html'
  default template_path: 'subscriptions/mailer'

  default from: "#{I18n.t 'layouts.application.title'} <noreply@otvorenesudy.sk>", css: 'mailer'

  layout 'mailer'

  helper ApplicationHelper
  helper SearchHelper
  helper SubscriptionsHelper

  helper CourtsHelper
  helper JudgesHelper
  helper HearingsHelper
  helper DecreesHelper

  helper TagHelper
  helper TextHelper
  helper TranslationHelper

  def results(subscription)
    @subscription = subscription

    @user    = @subscription.user
    @query   = @subscription.query
    @results = @subscription.results.first 10

    @type   = @query.model.underscore.to_sym
    @model  = @query.model.constantize
    @params = @query.value.merge! order: :desc, sort: :created_at

    mail to: @user.email, subject: I18n.t("subscriptions.mailer.results.subject.#{@type.to_s.pluralize}")
  end
end
