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
  end

  it 'is monthly unless given a period' do
    expect(described_class.new.period).to eq(Period.monthly)
  end
end
