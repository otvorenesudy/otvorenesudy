# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HearingAnonymizer do
  let(:initials) { /\A[A-Z]\. [A-Z]\.\z/ }

  it "reindexes the hearing's proceeding with the initials" do
    proceeding = create(:proceeding)
    hearing = create(:hearing, proceeding:, anonymized_at: nil)
    create(:opponent, hearing:, name: 'Ján Šťastný', name_unprocessed: 'Ján Šťastný')
    Proceeding.find(proceeding.id).update_index
    refresh_indices

    expect(Proceeding.search(q: 'Šťastný').total_count).to eq(1)

    described_class.new(hearing).anonymize!
    refresh_indices

    expect(hearing.opponents.sole.name).to match(initials)
    expect(Proceeding.search(q: 'Šťastný').total_count).to eq(0)
  end

  it 'replaces only the parties it is given' do
    hearing = create(:hearing, anonymized_at: nil)
    create(:proposer, hearing:, name: 'Mária Veselá', name_unprocessed: 'Mária Veselá')
    create(:defendant, hearing:, name: 'Peter Smutný', name_unprocessed: 'Peter Smutný')

    described_class.new(hearing).anonymize!(%i[defendants])

    expect(hearing.proposers.sole.name).to eq('Mária Veselá')
    expect(hearing.defendants.sole).to have_attributes(name: initials, name_unprocessed: initials)
    expect(hearing).to be_anonymized
  end
end
