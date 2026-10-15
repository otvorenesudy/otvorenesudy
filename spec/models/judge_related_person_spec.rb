# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JudgeRelatedPerson do
  it 'is the judge of the same name, until renamed' do
    judge = create(:judge, first: 'Mária', last: 'Nováková')
    person = create(:judge_related_person, name: 'JUDr. Mária Nováková')

    expect(person.to_judge).to eq(judge)
    expect(person.to_judge).to eq(judge)
    expect(person).to be_known_judge

    person.update!(name: 'Mária Malá')

    expect(person.to_judge).to be_nil
    expect(person).not_to be_known_judge
  end
end
