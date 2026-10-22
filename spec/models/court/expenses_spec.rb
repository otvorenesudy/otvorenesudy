# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Court::Expenses do
  describe '.rank' do
    it 'ranks the courts of a type by their total expenses, the most first' do
      court = create(:court)
      other = create(:court)
      regional = create(:court, :regional)
      create(:court_expense, court:, year: 2012, value: 10_000)
      create(:court_expense, court:, year: 2013, value: 30_000)
      create(:court_expense, court: other, value: 20_000)
      create(:court_expense, court: regional, value: 90_000)

      expect(described_class.rank(court)).to eq(1)
      expect(described_class.rank(other)).to eq(2)
      expect(described_class.rank(regional)).to eq(1)
    end
  end
end
