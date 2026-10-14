# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts' do
  it 'does not let a user make themselves an admin' do
    user = create(:user, password: 'correct horse battery')
    sign_in user

    patch user_registration_path, params: {
      user: { email: user.email, current_password: 'correct horse battery', admin: true }
    }

    expect(user.reload).not_to be_admin
  end

  it 'does not let a sign-up make an admin' do
    post user_registration_path, params: {
      user: { email: 'nova@example.com', password: 'correct horse battery',
              password_confirmation: 'correct horse battery', admin: true }
    }

    expect(User.find_by!(email: 'nova@example.com')).not_to be_admin
  end
end
