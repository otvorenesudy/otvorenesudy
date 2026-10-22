# frozen_string_literal: true

require 'rails_helper'

# Run by the maintainers from the console.
RSpec.describe DestroyModelJob do
  it 'destroys a record' do
    decree = create(:decree)

    described_class.perform_now('Decree', decree.id)

    expect(Decree.exists?(decree.id)).to be(false)
  end

  it 'refuses a name that is not a model' do
    expect { described_class.perform_now('Kernel', 1) }.to raise_error(ArgumentError)
  end
end
