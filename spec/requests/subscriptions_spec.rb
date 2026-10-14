# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions' do
  let(:owner) { create(:user) }
  let!(:subscription) { create(:subscription, user: owner, period: Period.monthly) }

  describe 'another user' do
    before { sign_in create(:user) }

    it 'cannot change a subscription that is not theirs' do
      patch subscription_path(subscription), params: { period_id: Period.daily.id }

      expect(response).to have_http_status(:not_found)
      expect(subscription.reload.period).to eq(Period.monthly)
    end

    it 'cannot cancel a subscription that is not theirs' do
      delete subscription_path(subscription)

      expect(response).to have_http_status(:not_found)
      expect(Subscription.exists?(subscription.id)).to be(true)
    end
  end

  describe 'subscribing to a listing without subscriptions' do
    it 'saves nothing and says the subscription failed' do
      sign_in owner

      post subscriptions_path, params: { period_id: Period.weekly.id,
                                         subscription: { query_attributes: { model: 'Court', value: '{}' } } }

      expect(response).to redirect_to(subscriptions_users_path(l: :sk))
      expect(flash[:failure]).to eq(I18n.t('subscriptions.create.failure'))
      expect(owner.subscriptions.reload).to eq([subscription])
    end
  end

  # The e-mail links to unsubscribe and names the same address in List-Unsubscribe. Link scanners open links, so a GET
  # only asks to confirm; the confirmation and the mail client's one-click request (RFC 8058) POST.
  describe 'unsubscribing by the link in the e-mail' do
    def log_of
      output = StringIO.new
      logger = ActiveSupport::Logger.new(output)
      Rails.logger.broadcast_to(logger)
      yield
      output.string
    ensure
      Rails.logger.stop_broadcasting_to(logger)
    end

    it 'moves the link to an address without the token, asks to confirm there and cancels nothing yet' do
      get unsubscribe_subscriptions_path(token: subscription.token)

      expect(response).to redirect_to(unsubscribe_subscriptions_path(l: :sk))

      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.css('form button').text).to include(I18n.t('subscriptions.unsubscribe.confirm'))
      expect(Subscription.exists?(subscription.id)).to be(true)
    end

    # Analytics reads the page's address, og:url names it and the confirmation sends it as its Referer.
    it 'keeps the token out of the addresses of the page, in the form it confirms with only' do
      get unsubscribe_subscriptions_path(token: subscription.token)
      follow_redirect!

      form = response.parsed_body.at_css('form')

      expect(request.fullpath).not_to include(subscription.token)
      expect(form['action']).not_to include(subscription.token)
      expect(form.at_css('input[name="token"]')['value']).to eq(subscription.token)
      expect(response.body.scan(subscription.token).size).to eq(1)
    end

    it 'cancels the subscription its page asked about, though another link was opened since' do
      other = create(:subscription, user: owner, query: create(:query, :hearings))

      get unsubscribe_subscriptions_path(token: subscription.token)
      follow_redirect!
      token = response.parsed_body.at_css('form input[name="token"]')['value']

      get unsubscribe_subscriptions_path(token: other.token)
      post unsubscribe_subscriptions_path, params: { token: }

      expect(Subscription.exists?(subscription.id)).to be(false)
      expect(Subscription.exists?(other.id)).to be(true)
    end

    it 'cancels the subscription when confirmed' do
      post unsubscribe_subscriptions_path(token: subscription.token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t('subscriptions.mailer.results.unsubscribed.notice'))
      expect(Subscription.exists?(subscription.id)).to be(false)
    end

    it 'cancels the subscription by a one-click request of the mail client' do
      post unsubscribe_subscriptions_path(token: subscription.token), params: { 'List-Unsubscribe' => 'One-Click' }

      expect(response).to have_http_status(:ok)
      expect(Subscription.exists?(subscription.id)).to be(false)
    end

    it 'cancels nothing for an unknown token' do
      get unsubscribe_subscriptions_path(token: 'unknown')
      follow_redirect!

      expect(response.body).to include(I18n.t('subscriptions.unsubscribe.unknown'))

      post unsubscribe_subscriptions_path(token: 'unknown')

      expect(response.body).to include(I18n.t('subscriptions.unsubscribe.unknown'))
      expect(Subscription.count).to eq(1)
    end

    it 'cancels nothing for a link cut off before its token' do
      get unsubscribe_subscriptions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t('subscriptions.unsubscribe.unknown'))

      post unsubscribe_subscriptions_path

      expect(response.body).to include(I18n.t('subscriptions.unsubscribe.unknown'))
      expect(Subscription.count).to eq(1)
    end

    it 'asks to confirm, at an address without the token, from a link sent before the token moved to the query' do
      get "/subscriptions/unsubscribe/#{subscription.token}"

      expect(response).to redirect_to(unsubscribe_subscriptions_path(l: :sk))

      follow_redirect!

      expect(response.parsed_body.css('form button').text).to include(I18n.t('subscriptions.unsubscribe.confirm'))
      expect(Subscription.exists?(subscription.id)).to be(true)
    end

    it 'keeps the token out of the log' do
      log = log_of do
        get unsubscribe_subscriptions_path(token: subscription.token)
        get "/subscriptions/unsubscribe/#{subscription.token}"
        post unsubscribe_subscriptions_path(token: subscription.token)
      end

      expect(log).to include('/subscriptions/unsubscribe')
      expect(log).not_to include(subscription.token)
    end
  end
end
