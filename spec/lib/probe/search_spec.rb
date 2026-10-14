# frozen_string_literal: true

require 'rails_helper'

# Model.search: a listing's params in, a page of results with their facets out (the listings in spec/system and
# spec/requests show it on the pages). These are the parts of it the pages don't use.
RSpec.describe Probe::Search do
  it 'searches an index without full text, which has nothing to highlight' do
    decree = create(:decree)
    create(:decree_page, decree:, number: 1)
    refresh_indices

    results = DecreePage.search({})

    expect(results.records.map(&:decree)).to eq([decree])
    expect(results.highlights).to eq([{}])
  end

  describe 'paging' do
    before do
      21.times { |n| create(:court, name: format('Okresný súd %02d', n + 1)) }
      refresh_indices
    end

    it 'tells the first page, and the page after it' do
      expect(Court.search({})).to have_attributes(
        total_pages: 2,
        first_page?: true,
        last_page?: false,
        previous_page: nil,
        next_page: 2,
        out_of_range?: false
      )
    end

    it 'tells the last page, and the page before it' do
      expect(Court.search(page: 2)).to have_attributes(
        first_page?: false,
        last_page?: true,
        previous_page: 1,
        next_page: nil
      )
    end

    it 'tells a page beyond the results' do
      expect(Court.search(page: 3)).to be_out_of_range
    end
  end

  it 'filters by a range given as a Ruby range' do
    create(:hearing, case_number: '1C/1/2026', date: Time.zone.local(2026, 3, 4, 9))
    create(:hearing, case_number: '2C/1/2026', date: Time.zone.local(2026, 5, 6, 9))
    refresh_indices

    results = Hearing.search(date: [Date.new(2026, 3, 1)..Date.new(2026, 3, 31)])

    expect(results.records.map(&:case_number)).to eq(['1C/1/2026'])
  end

  # Only a full-text query can be searched again, as plain words; other errors are the search's to report.
  it 'raises the error of a search without full text' do
    expect { Court.search(judges_count: ['3000000000..Infinity']) }.to raise_error(
      Elastic::Transport::Transport::Errors::BadRequest,
      /out of range/
    )
  end
end
