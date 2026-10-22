# frozen_string_literal: true

# The new results of a saved search, in Slovak (the site's language for e-mails), with links to unsubscribe for the
# reader and for the mail client (RFC 8058).
class SubscriptionMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  default template_path: 'subscriptions/mailer'

  helper ApplicationHelper, SearchHelper, SubscriptionsHelper, TagHelper, TextHelper, TranslationHelper
  helper CourtsHelper, JudgesHelper, HearingsHelper, DecreesHelper
  helper Bootstrap::ImageHelper, Bootstrap::TooltipHelper, Bootstrap::PopoverHelper

  def results(subscription)
    @subscription = subscription
    @query = subscription.query
    @results = subscription.results.first(10)
    @type = @query.model.underscore.to_sym
    @params = @query.value.merge(order: :desc, sort: :created_at)
    @unsubscribe_url = unsubscribe_subscriptions_url(token: subscription.token)

    headers['List-Unsubscribe'] = "<#{@unsubscribe_url}>"
    headers['List-Unsubscribe-Post'] = 'List-Unsubscribe=One-Click'

    I18n.with_locale(:sk) do
      mail to: subscription.user.email, subject: t("subscriptions.mailer.results.subject.#{@type.to_s.pluralize}")
    end
  end
end
