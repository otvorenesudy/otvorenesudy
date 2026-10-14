# frozen_string_literal: true

require 'rails_helper'

# The Sidekiq dashboard lists, retries and deletes jobs: admins only.
RSpec.describe 'Sidekiq dashboard' do
  it 'asks a visitor to sign in' do
    get '/sidekiq'

    expect(response).to redirect_to('/users/sign_in')
  end

  it 'is not found for a user who is not an admin' do
    sign_in create(:user)

    get '/sidekiq'

    expect(response).to have_http_status(:not_found)
  end

  it 'opens for an admin' do
    sign_in create(:user, :admin)

    get '/sidekiq'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Sidekiq')
  end
end
