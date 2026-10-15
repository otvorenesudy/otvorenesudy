# frozen_string_literal: true

require 'rails_helper'

# The dataset (data/court_average_proceeding_durations.json) has the yearly averages of the district courts by name.
RSpec.describe Court::AverageProceedingDurations do
  let!(:bardejov) { create(:court, name: 'Okresný súd Bardejov') }
  let!(:bystrica) { create(:court, name: 'Okresný súd Banská Bystrica') }

  describe '#average_proceeding_durations' do
    it "lists a court's agendas with their averages, the latest year first" do
      agendas = bardejov.average_proceeding_durations

      expect(agendas.map(&:acronym)).to eq(%i[C Cb P T])
      expect(agendas.by_acronym('C').name).to eq('Občiansko-právne')
      expect(agendas.by_acronym(:C).data.pluck(:year, :value)).to eq(
        [%w[2013 15.12], %w[2012 14.72], %w[2011 14.35], %w[2010 14.52]]
      )
    end

    it 'is nil for a court not in the dataset' do
      expect(create(:court).average_proceeding_durations).to be_nil
    end
  end

  describe Court::AverageProceedingDurations::Ranking do
    it 'ranks the district and municipal courts in the dataset by their averages of an agenda, the slowest first' do
      create(:court)
      create(:court, :regional)

      expect(described_class.courts.count).to eq(3)
      expect(described_class.rank(bardejov, :C)).to eq(1)
      expect(described_class.rank(bystrica, 'C')).to eq(2)
      expect(described_class.rank_with_order(bystrica, :C)).to eq(rank: 1, order: :asc)
    end

    it 'ranks no court by an agenda the dataset does not have' do
      expect(described_class.rank(bardejov, :Xyz)).to be_nil
    end
  end
end
