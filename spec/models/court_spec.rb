# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Court do
  describe '#coordinates' do
    it 'gives the latitude and longitude, and the new ones once saved' do
      court = create(:court, latitude: 48.7164, longitude: 21.2611)

      expect(court.coordinates).to eq(latitude: BigDecimal('48.7164'), longitude: BigDecimal('21.2611'))

      court.update!(latitude: 48.1486, longitude: 17.1077)

      expect(court.coordinates).to eq(latitude: BigDecimal('48.1486'), longitude: BigDecimal('17.1077'))
    end
  end
end
