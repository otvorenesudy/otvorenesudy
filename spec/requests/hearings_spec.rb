# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hearings' do
  describe 'DELETE /hearings/:id/anonymize' do
    let(:hearing) { create(:hearing, anonymized_at: nil) }

    before { create(:opponent, hearing:, name: 'Ján Šťastný') }

    it 'is not found for a visitor' do
      delete anonymize_hearing_path(hearing)

      expect(response).to have_http_status(:not_found)
      expect(hearing.reload).not_to be_anonymized
    end

    it 'is not found for a user who is not an admin' do
      sign_in create(:user)

      delete anonymize_hearing_path(hearing)

      expect(response).to have_http_status(:not_found)
      expect(hearing.opponents.pluck(:name)).to eq(['Ján Šťastný'])
    end
  end
end
