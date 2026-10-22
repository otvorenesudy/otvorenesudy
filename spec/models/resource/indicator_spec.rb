# frozen_string_literal: true

require 'rails_helper'

# Court indicates Court::AverageProceedingDurations, read from data/court_average_proceeding_durations.json.
RSpec.describe Resource::Indicator do
  let(:court) { create(:court, name: 'Okresný súd Bardejov') }

  it 'computes an indicator once per record, until invalidated' do
    durations = court.average_proceeding_durations

    expect(court).to be_average_proceeding_durations
    expect(Court.find(court.id).average_proceeding_durations).to be(durations)

    Court.invalidate_indicators!

    expect(court.average_proceeding_durations).not_to be(durations)
    expect(court.average_proceeding_durations.map(&:acronym)).to eq(durations.map(&:acronym))
  end
end
