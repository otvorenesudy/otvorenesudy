# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JudgeStatisticalSummary do
  let(:judge) { create(:judge) }
  let(:district) { create(:court) }
  let(:regional) { create(:court, :regional) }

  # A summary with the cases assigned to the judge that year (table P, its first row).
  def summary(court:, year:, assigned: nil)
    create(:judge_statistical_summary, judge:, court:, year:).tap do |summary|
      rows = { 'Pocet' => { 'C' => assigned.to_s, 'T' => '0' } }

      create(:statistical_table, summary:, table_name: 'P', rows:) if assigned
    end
  end

  describe '.by_prominent_court_type' do
    it 'keeps the summaries from the type of court the judge has the most of' do
      at_district = [summary(court: district, year: 2011), summary(court: district, year: 2012)]
      summary(court: regional, year: 2012)

      expect(judge.statistical_summaries.by_prominent_court_type(judge)).to match_array(at_district)
    end

    it 'keeps, when the types are even, the type the judge was assigned the most cases at in the latest year' do
      regional_2011 = summary(court: regional, year: 2011, assigned: 10)
      regional_2012 = summary(court: regional, year: 2012, assigned: 120)
      summary(court: district, year: 2011, assigned: 900)
      summary(court: district, year: 2012, assigned: 40)

      summaries = judge.statistical_summaries.by_prominent_court_type(judge)

      expect(summaries).to contain_exactly(regional_2011, regional_2012)
    end

    it 'keeps nothing for a judge without summaries' do
      summary(court: district, year: 2012)
      other = create(:judge)

      expect(other.statistical_summaries.by_prominent_court_type(other)).to be_empty
    end
  end

  describe '#assigned_issues_count' do
    it 'sums the first row of the assigned cases' do
      expect(summary(court: district, year: 2012, assigned: 120).assigned_issues_count).to eq(120)
    end

    it 'is zero without the table' do
      expect(summary(court: district, year: 2012).assigned_issues_count).to eq(0)
    end
  end
end
