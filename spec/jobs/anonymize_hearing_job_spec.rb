# frozen_string_literal: true

require 'rails_helper'

# Run by the maintainers from the console.
RSpec.describe AnonymizeHearingJob do
  it "replaces a hearing's parties by initials" do
    hearing = create(:hearing, anonymized_at: nil)
    create(:opponent, hearing:, name: 'Ján Šťastný', name_unprocessed: 'Ján Šťastný')

    described_class.perform_now(hearing.id)

    expect(hearing.reload).to be_anonymized
    expect(hearing.opponents.sole.name).to match(/\A[A-Z]\. [A-Z]\.\z/)
  end
end
