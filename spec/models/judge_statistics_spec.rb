# frozen_string_literal: true

require 'rails_helper'

# The indicators read from the statistical tables of the judges' yearly summaries (2011, 2012): the cases (table N)
# and the appeals (table O), a row per count and a column per agenda.
RSpec.describe Judge do
  let(:judge) { create(:judge) }
  let(:court) { create(:court) }

  # A summary of the year with its tables of the cases (N) and the appeals (O).
  def summary(year, cases: nil, appeals: nil, judge: self.judge)
    create(:judge_statistical_summary, judge:, court:, year:).tap do |summary|
      tables = { 'N' => cases, 'O' => appeals }.compact

      tables.each { |name, rows| create(:statistical_table, summary:, table_name: name, rows:) }
    end
  end

  # The rows of table N in order: the cases assigned during the year, unfinished at its end, of them suspended and set
  # aside, another count, then the unresolved and the unfinished ones carried over from the year before.
  def case_counts(**counts)
    rows = %w[sv_Pocet1 sv_Pocet2 sv_Pocet3 sv_Pocet4 sv_Pocet5 sv_PrenosN1 sv_PrenosN2]
    keys = %i[assigned unfinished suspended set_aside other unresolved_before unfinished_before]

    rows.zip(keys).to_h { |row, key| [row, { 'C' => counts.fetch(key, 0).to_s, 'T' => '0' }] }
  end

  # Upheld by the appeal court (sv_Pocet1), and the other outcomes.
  def appeal_counts(upheld:, other:)
    { 'sv_Pocet1' => { 'C' => upheld.to_s, 'T' => '0' }, 'sv_Pocet2' => { 'C' => other.to_s, 'T' => '0' } }
  end

  describe '#unfinished_issues_counts' do
    it 'gives per year how many more cases were unfinished at its end than carried over into it' do
      summary(2011, cases: case_counts(assigned: 9, unfinished: 4, unfinished_before: 6))
      summary(2012, cases: case_counts(assigned: 12, unfinished: 8, unfinished_before: 5))

      expect(judge.unfinished_issues_counts).to eq(2011 => -2, 2012 => 3)
    end

    it 'is nil for a judge without summaries' do
      expect(judge.unfinished_issues_counts).to be_nil
    end
  end

  describe '#unfinished_issues_rate' do
    it 'gives per year the cases unfinished, less those suspended or set aside, against those assigned' do
      summary(2012, cases: case_counts(assigned: 12, unfinished: 8, suspended: 1, set_aside: 1))

      expect(judge.unfinished_issues_rate).to eq(2012 => 0.5)
    end

    it 'is zero for a year without cases assigned' do
      summary(2011, cases: case_counts(assigned: 0, unfinished: 3))

      expect(judge.unfinished_issues_rate).to eq(2011 => 0.0)
    end

    it 'is nil for a judge without summaries' do
      expect(judge.unfinished_issues_rate).to be_nil
    end
  end

  describe '#unresolved_issues_counts' do
    it 'gives per year how many more cases were assigned than carried over unresolved into it' do
      summary(2012, cases: case_counts(assigned: 12, unfinished: 8, unresolved_before: 3))

      expect(judge.unresolved_issues_counts).to eq(2012 => 9)
    end

    it 'is nil for a judge without summaries' do
      expect(judge.unresolved_issues_counts).to be_nil
    end
  end

  describe '#appeal_court_acceptance_rate' do
    it 'gives the share of appealed decisions the appeal court upheld, over the years' do
      summary(2011, appeals: appeal_counts(upheld: 5, other: 1))
      summary(2012, appeals: appeal_counts(upheld: 3, other: 1))

      expect(judge.appeal_court_acceptance_rate).to eq(0.8)
    end

    it 'is zero for a judge whose decisions were not appealed' do
      summary(2012, appeals: appeal_counts(upheld: 0, other: 0))

      expect(judge.appeal_court_acceptance_rate).to eq(0)
    end

    it 'is nil for a judge without summaries' do
      expect(judge.appeal_court_acceptance_rate).to be_nil
    end
  end

  describe '.average_appeal_court_acceptance_rate' do
    it 'averages the rates of the judges with summaries' do
      summary(2012, appeals: appeal_counts(upheld: 3, other: 1), judge: create(:judge))
      summary(2012, appeals: appeal_counts(upheld: 1, other: 3), judge: create(:judge))
      create(:judge)

      expect(described_class.average_appeal_court_acceptance_rate).to eq(0.5)
    end
  end
end
