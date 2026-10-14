# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Judge do
  let(:judge) { create(:judge) }
  let(:court) { create(:court) }

  # A property declaration of the judge naming people related to the judge.
  def declare(judge, year, *names)
    create(:judge_property_declaration, judge:, year:).tap do |declaration|
      names.each { |name| create(:judge_related_person, property_declaration: declaration, name:) }
    end
  end

  describe '#active_at' do
    it 'is true at a court the judge works at' do
      create(:employment, :active, judge:, court:)

      expect(judge.active_at(court)).to be(true)
    end

    it 'is false at a court the judge left' do
      create(:employment, :inactive, judge:, court:)

      expect(judge.active_at(court)).to be(false)
    end

    it 'is nil at a court the judge never worked at' do
      create(:employment, :active, judge:)

      expect(judge.active_at(court)).to be_nil
    end
  end

  describe '#probable_gender' do
    it 'is female for a surname ending in -ová or -ská' do
      expect(build(:judge, last: 'Nováková').probable_gender).to eq(:female)
      expect(build(:judge, last: 'Kovalská').probable_gender).to eq(:female)
    end

    it 'is male otherwise' do
      expect(build(:judge, last: 'Novák').probable_gender).to eq(:male)
    end
  end

  describe '#incomes_by_year' do
    it 'lists the incomes of the years declaring some, latest first' do
      older = create(:judge_property_declaration, judge:, year: 2011)
      newer = create(:judge_property_declaration, judge:, year: 2013)
      create(:judge_property_declaration, judge:, year: 2012)
      salary = create(:judge_income, property_declaration: older, value: 30_000)
      rent = create(:judge_income, property_declaration: newer, description: 'príjmy z prenájmu', value: 6_000)

      expect(judge.incomes_by_year).to eq([[2013, [rent]], [2011, [salary]]])
    end
  end

  describe '#related_people_by_year' do
    it 'lists the people of the years naming some, by name' do
      declare(judge, 2012, 'Zuzana Nová', 'Adam Nový')
      declare(judge, 2013)

      names = judge.related_people_by_year.map { |year, people| [year, people.map(&:name)] }

      expect(names).to eq([[2012, ['Adam Nový', 'Zuzana Nová']]])
    end
  end

  describe '.at_least_one_related_person_rate' do
    it 'gives the share of the judges declaring property who name a related person' do
      declare(create(:judge), 2012, 'Zuzana Nová')
      declare(create(:judge), 2012)

      expect(described_class.at_least_one_related_person_rate).to eq(0.5)
    end
  end

  describe '.with_most_related_people' do
    it 'finds the judges naming the most people, each person once' do
      over_years = create(:judge)
      declare(over_years, 2012, 'Eva Nová')
      declare(over_years, 2013, 'Eva Nová', 'Ján Nový')
      at_once = create(:judge)
      declare(at_once, 2012, 'Mária Malá', 'Peter Malý')
      declare(create(:judge), 2012, 'Oto Veľký')

      expect(described_class.with_most_related_people).to contain_exactly(over_years, at_once)
    end
  end

  describe '#substantiation_notes_by_year' do
    it 'lists the notes of the years with some, latest first' do
      create(:judge_statistical_summary, judge:, year: 2011, substantiation_notes: 'Vysoký nápad vecí')
      create(:judge_statistical_summary, judge:, year: 2012, substantiation_notes: nil)

      expect(judge.substantiation_notes_by_year).to eq([[2011, 'Vysoký nápad vecí']])
    end
  end

  describe 'constitutional decrees' do
    it 'totals the decrees released and delayed over the summaries' do
      create(:judge_statistical_summary, judge:, year: 2011, released_constitutional_decrees: 3,
                                         delayed_constitutional_decrees: 1)
      create(:judge_statistical_summary, judge:, year: 2012, released_constitutional_decrees: 2)

      expect(judge.released_constitutional_decrees_total).to eq(5)
      expect(judge.delayed_constitutional_decrees_total).to eq(1)
    end
  end
end
