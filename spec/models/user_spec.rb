require 'spec_helper'

RSpec.describe User do
  it 'does not allow to set admin on mass-assignment' do
    expect {
      User.new(email: 'samuel@gmail.com', admin: true)
    }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
end
