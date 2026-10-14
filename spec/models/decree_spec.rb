# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Decree do
  describe 'without a date or form' do
    let!(:decree) { create(:decree, date: nil, form: nil, case_number: '5C/1/2026') }

    it 'has no time, is not from the future and is found by its case number' do
      refresh_indices

      expect(decree.time).to be_nil
      expect(decree.future_date?).to be_nil
      expect(described_class.search(case_number: ['5C/1/2026']).records).to eq([decree])
    end
  end

  describe '#time' do
    it 'is the end of its day' do
      decree = build(:decree, date: Date.new(2026, 3, 4))

      expect(decree.time).to eq(Date.new(2026, 3, 4).to_datetime.end_of_day)
    end
  end
end
