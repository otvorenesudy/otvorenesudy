# frozen_string_literal: true

require 'rails_helper'

# The 2013 indicators match judges by name: Gallo is in both of its tables, Guľová in the statistical one only.
RSpec.describe Judge::Indicators do
  let(:dataset) { Judge::Indicators2013::DATASET }

  let!(:kosice) { create(:court, name: 'Mestský súd Košice') }
  let!(:gallo) { create(:judge, first: 'Ján', last: 'Gallo', name: 'JUDr. Ján Gallo') }
  let!(:gulova) { create(:judge, first: 'Emília', last: 'Guľová', addition: 'ml.', name: 'JUDr. Emília ml. Guľová') }

  # Indexing a judge reads the dataset; read it again for all of these judges.
  before { dataset.reset! }

  it "normalizes a judge's statistical values: missing ones, dashes and courts" do
    statistical = dataset.for(gulova).statistical

    expect(statistical['S9']).to be_nil
    expect(statistical['S3']).to eq('2012 – 2013')
    expect(statistical['S3_2012']).to eq([kosice])
  end

  describe '#numerical_values_for' do
    it 'gives the scores the chart shows' do
      expect(dataset.numerical_values_for(gallo)).to eq([10, 10, 10, 10, 9, 9, 10, 9])
    end

    it 'gives none for a judge without scores or without indicators' do
      expect(dataset.numerical_values_for(gulova)).to be_nil
      expect(dataset.numerical_values_for(create(:judge))).to be_nil
    end
  end

  describe '#numerical_average' do
    it 'averages each score over the judges in the dataset, those without scores included' do
      expect(dataset.numerical_average).to eq(
        'IND_1' => 5.0,
        'IND_2' => 5.0,
        'IND_3' => 5.0,
        'IND_4' => 5.0,
        'IND_5' => 4.5,
        'IND_6' => 4.5,
        'IND_7' => 5.0,
        'IND_8' => 4.5
      )
    end
  end
end
