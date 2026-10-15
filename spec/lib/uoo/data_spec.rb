# frozen_string_literal: true

require 'rails_helper'

# The decisions of the Whistleblower Protection Office as published, with what the published data gets wrong:
# undated decisions, unreadable dates, unnamed parties and a source address that isn't a web address.
RSpec.describe Uoo::Data do
  before do
    stub_const('Uoo::Data::SOURCE', file_fixture('uoo-decrees.json'))
    described_class.reload!
  end

  after { described_class.reload! }

  it 'lists dated decisions first, newest first, then the undated ones' do
    expect(described_class.decrees.pluck('title'))
      .to eq(['1. Rozhodnutie', '2. Rozhodnutie bez dátumu', '3. Rozhodnutie s nečitateľným dátumom'])
    expect(described_class.decrees.first['parsed_date']).to eq(Date.new(2025, 3, 1))
  end

  it 'counts the decisions and fines of each named party' do
    expect(described_class.stats).to eq(
      total_count: 3, total_fine: 500, currency: 'EUR',
      by_party: [{ name: 'Obec Sološnica', count: 2, fine: 500, currency: 'EUR' }]
    )
  end

  it 'gives no source address that is not a web address' do
    expect(described_class.source_url).to be_nil
  end
end
