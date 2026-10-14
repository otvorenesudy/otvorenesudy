# frozen_string_literal: true

require 'rails_helper'

# Saved searches (subscriptions) are registered in each model's percolator, so a record tells which of them it matches.
RSpec.describe Probe::Percolator do
  let(:court) { create(:court, name: 'Okresný súd Košice I') }

  def subscription(value)
    create(:subscription, query: create(:query, value:))
  end

  it 'matches a record to the searches that would find it' do
    matching = subscription(court: ['Okresný súd Košice I'])
    other = subscription(court: ['Okresný súd Bratislava I'])
    everything = subscription({})

    subscriptions = create(:decree, court:).subscriptions

    expect(subscriptions).to include(matching, everything)
    expect(subscriptions).not_to include(other)
  end

  it 'forgets a search no longer saved' do
    saved = subscription(court: ['Okresný súd Košice I'])

    Decree.unsubscribe(saved.query.id)

    expect(create(:decree, court:).subscriptions).to be_empty
  end
end
