# frozen_string_literal: true

require 'rails_helper'

# The nightly check of the hearings and decrees indices (config/schedule.rb).
RSpec.describe Probe::Index do
  def case_numbers
    Hearing.search({}).records.map(&:case_number).sort
  end

  it 'indexes the records missing from the index' do
    hearing = create(:hearing, case_number: '1C/1/2026')
    Hearing.client.delete(index: Hearing.index_name, id: hearing.id, refresh: true)

    Hearing.recheck_index

    expect(case_numbers).to eq(['1C/1/2026'])
  end

  it 'deletes the documents of records no longer in the database' do
    create(:hearing, case_number: '1C/1/2026')
    gone = create(:hearing, case_number: '2C/1/2026')
    gone.delete
    refresh_indices

    Hearing.consolidate_index
    refresh_indices

    expect(Hearing.search({}).total_count).to eq(1)
    expect(case_numbers).to eq(['1C/1/2026'])
  end
end
