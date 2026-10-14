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

  describe 'unsubscribing by the link in the e-mail' do
    it 'cancels the subscription from the link' do
      get unsubscribe_subscriptions_path(token: subscription.token)

      expect(response).to redirect_to(root_path(l: :sk))
      expect(flash[:notice]).to eq(I18n.t('subscriptions.mailer.results.unsubscribed.notice'))
      expect(Subscription.exists?(subscription.id)).to be(false)
    end

    it 'cancels the subscription by a one-click request of the mail client' do
      post unsubscribe_subscriptions_path(token: subscription.token), params: { 'List-Unsubscribe' => 'One-Click' }

      expect(Subscription.exists?(subscription.id)).to be(false)
    end

    it 'cancels nothing for an unknown token' do
      get unsubscribe_subscriptions_path(token: 'unknown')

      expect(response).to redirect_to(root_path(l: :sk))
      expect(Subscription.count).to eq(1)
    end
  end
end
