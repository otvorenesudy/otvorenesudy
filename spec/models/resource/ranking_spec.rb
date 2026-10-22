# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource::Ranking do
  subject(:ranking) { described_class.new(values.keys) { |key| values[key] } }

  let(:values) { { a: 9, b: 7, c: 7, d: 5 } }

  it 'ranks from the highest value, ties sharing their ranks' do
    expect(ranking.descending[:a]).to eq(1)
    expect(ranking.descending[:b]).to eq(2..3)
    expect(ranking.descending[:c]).to eq(2..3)
    expect(ranking.descending[:d]).to eq(4)
  end

  it 'ranks from the lowest value' do
    expect(ranking.ascending.each.to_a).to eq([[:d, 1], [:b, 2..3], [:c, 2..3], [:a, 4]])
  end

  it 'reads the rank from the end the object is closer to' do
    expect(ranking.rank_with_order(:a)).to eq(rank: 1, order: :desc)
    expect(ranking.rank_with_order(:b)).to eq(rank: 2..3, order: :asc)
    expect(ranking.rank_with_order(:d)).to eq(rank: 1, order: :asc)
  end
end
