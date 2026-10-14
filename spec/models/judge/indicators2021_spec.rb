# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Judge::Indicators2021 do
  describe '.chart_bounds' do
    it 'bounds each value of the chart by its maximum over the judges evaluated' do
      create(:judge, id: 194, first: 'Ivan', last: 'Ďalak', name: 'JUDr. Ivan Ďalak')
      create(:judge, id: 1492, first: 'Margita', last: 'Žilková', name: 'JUDr. Margita Žilková')
      described_class.reset!

      expect(described_class.chart_bounds).to eq(
        arrears: 24.51,
        availability: 128.0,
        ratio: 122.41,
        decrees_approved: 230.0,
        weighted_product: 292.732
      )
    end
  end
end
