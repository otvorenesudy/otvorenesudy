# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription do
  describe '#token' do
    it 'is generated on create' do
      expect(create(:subscription).token).to be_present
    end

    it 'differs between subscriptions' do
      first = create(:subscription, :weekly)
      second = create(:subscription, :daily, user: first.user, query: first.query)

      expect(first.token).not_to eq(second.token)
    end

    it 'is drawn again when the one drawn is taken' do
      taken = create(:subscription).token
      user = create(:user)
      query = create(:query, :hearings)
      allow(SecureRandom).to receive('urlsafe_base64').and_call_original
      allow(SecureRandom).to receive('urlsafe_base64').with(24).and_return(taken, 'drawn-again')

      expect(create(:subscription, user:, query:).token).to eq('drawn-again')
    end

    it 'is kept when given' do
      expect(create(:subscription, token: 'given-token').token).to eq('given-token')
    end
  end

  it 'is monthly unless given a period' do
    expect(described_class.new.period).to eq(Period.monthly)
  end

  it 'loads without its period when not selecting it' do
    subscription = create(:subscription, :weekly)

    loaded = described_class.select(:id, :token).find(subscription.id)

    expect(loaded.token).to eq(subscription.token)
    expect(loaded).not_to have_attribute(:period_id)
  end
end
