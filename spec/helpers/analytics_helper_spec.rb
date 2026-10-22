# frozen_string_literal: true

require 'rails_helper'

# No view tracks events with it; kept, as the owner asked to keep unused code.
RSpec.describe AnalyticsHelper do
  it 'describes an event by data attributes, its parts lowercased and joined' do
    expect(helper.track(%w[Search Courts], 'Submit', nil, class: 'btn')).to eq(
      class: 'btn', data: { 'track-category': 'search - courts', 'track-action': 'submit' }
    )
  end
end
