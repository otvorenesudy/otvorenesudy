# frozen_string_literal: true

require 'rails_helper'

# Judge includes Resource::Similarity; the dataset loader matches judges by name with it.
RSpec.describe Resource::Similarity do
  let!(:novak) { create(:judge, first: 'Ján', last: 'Novák') }
  let!(:novakova) { create(:judge, first: 'Jana', last: 'Nováková') }

  before { create(:judge, first: 'Peter', last: 'Kováč') }

  it 'groups the records at least as similar as the limit by their similarity, the most similar first' do
    similar = Judge.similar_by_name('JUDr. Ján Novák', limit: 0.5)

    expect(similar.values).to eq([[novak], [novakova]])
    expect(similar.keys.first).to eq(1.0)
    expect(similar.keys.last).to be_within(0.001).of(0.526)
  end

  it 'finds only the same value by default' do
    expect(Judge.similar_by_name('JUDr. Ján Novák')).to eq(1.0 => [novak])
  end

  it 'compares without diacritics through unaccent' do
    expect(Judge.similar_by_name('JUDr. Jan Novak', function: :unaccent)).to eq(1.0 => [novak])
    expect(Judge.similar_by_name('JUDr. Jan Novak')).to be_empty
  end

  it 'refuses a limit outside (0, 1]' do
    expect { Judge.similar_by_name('JUDr. Ján Novák', limit: 0) }.to raise_error(ArgumentError, /isn't in \(0, 1\]/)
    expect { Judge.similar_by_name('JUDr. Ján Novák', limit: 1.5) }.to raise_error(ArgumentError)
  end

  it 'refuses a function other than unaccent' do
    expect { Judge.similar_by_name('JUDr. Ján Novák', function: :lower) }.to raise_error(
      ArgumentError,
      'Unknown function lower'
    )
  end
end
