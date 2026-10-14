# frozen_string_literal: true

require 'rails_helper'

# Enqueued by `bin/rails probe:synchronize` (spec/tasks/probe_spec.rb) for each id range of up to 10,000 records.
RSpec.describe SynchronizeRepositoryJob do
  it 'does nothing for an id range whose records were deleted meanwhile' do
    court = create(:court)
    court.destroy!

    expect { described_class.perform_now('Court', court.id, court.id) }.not_to raise_error
  end
end
