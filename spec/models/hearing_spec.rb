# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hearing do
  let(:initials) { /\A[A-Z]\. [A-Z]\.\z/ }

  describe 'without a date' do
    let(:hearing) { create(:hearing, date: nil) }

    it 'has no time and is neither past nor too far ahead' do
      expect(hearing.time).to be_nil
      expect(hearing).not_to be_historical
      expect(hearing.future_date?).to be_nil
    end
  end

  describe 'search' do
    it 'finds a hearing by its section and by its accusations with their paragraphs' do
      hearing = create(:hearing, :criminal, section: create(:hearing_section, value: 'Trestný úsek'))
      accusation = Accusation.create!(defendant: create(:defendant, hearing:), value: 'Krádež',
                                      value_unprocessed: 'Krádež')
      paragraph = Paragraph.create!(legislation: 300, number: '212', description: 'Trestného zákona o krádeži')
      ParagraphExplanation.create!(paragraph:, explainable: accusation)
      described_class.find(hearing.id).update_index
      create(:hearing)
      refresh_indices

      expect(described_class.search(section: ['Trestný úsek']).records).to eq([hearing])
      expect(described_class.search(q: 'krádež').records).to eq([hearing])
      expect(described_class.search(q: 'zákona').records).to eq([hearing])
    end
  end

  describe '#social_security_case?' do
    let(:hearing) { create(:hearing) }

    it 'is true when a party is the Social Insurance Agency, however written' do
      create(:opponent, hearing:, name: 'Sociálna poisťovňa, pobočka Košice')

      expect(hearing).to be_social_security_case
    end

    it 'reads the parties already loaded' do
      create(:proposer, hearing:, name: 'SOCIALNA  POISTOVNA')

      expect(described_class.includes(:defendants, :opponents, :proposers).find(hearing.id)).to be_social_security_case
    end

    it 'is false for other parties' do
      create(:defendant, hearing:, name: 'Ján Šťastný')

      expect(hearing).not_to be_social_security_case
    end
  end

  describe '.anonymize_anonymizable_hearings!' do
    it 'anonymizes the parties of the hearings not anonymized yet' do
      pending = create(:hearing, anonymized_at: nil)
      create(:opponent, hearing: pending, name: 'Ján Šťastný', name_unprocessed: 'Ján Šťastný')
      anonymized = create(:hearing, anonymized_at: 1.day.ago)
      create(:opponent, hearing: anonymized, name: 'Mária Veselá', name_unprocessed: 'Mária Veselá')

      described_class.anonymize_anonymizable_hearings!

      expect(pending.reload).to be_anonymized
      expect(pending.opponents.sole.name).to match(initials)
      expect(anonymized.opponents.sole.name).to eq('Mária Veselá')
    end
  end
end
