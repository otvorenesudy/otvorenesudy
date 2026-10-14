# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Judges' do
  def link(text)
    Capybara.string(response.body).find_link(text)[:href]
  end

  describe 'GET /judges/suggest' do
    let(:dalak) { create(:judge, id: 194, first: 'Ivan', last: 'Ďalak', name: 'JUDr. Ivan Ďalak') }

    # Ďalak and Žilková have the 2017 indicators (data/), so they are compared in that year.
    before do
      zilkova = create(:judge, id: 1492, first: 'Margita', last: 'Žilková', name: 'JUDr. Margita Žilková')
      create(:employment, judge: dalak, court: create(:court, name: 'Okresný súd Poprad'))
      create(:employment, judge: zilkova)
      [dalak, zilkova].each(&:update_index)
      refresh_indices
    end

    it 'links the courts suggested in the listing to the listing' do
      get suggest_judges_path(facet: 'courts', term: 'popr')

      expect(link('Okresný súd Poprad')).to eq(judges_url(courts: 'Okresný súd Poprad', l: :sk))
    end

    it 'links the judges suggested to compare with to the tab of the year on the page of the judge' do
      get suggest_judges_path(facet: 'name', term: 'zilk', id: dalak.id, indicators_2017: ['true'])

      expect(link('JUDr. Margita Žilková')).to eq(
        judge_path(dalak, indicators_2017: ['true'], name: 'JUDr. Margita Žilková', l: :sk, anchor: 'indicators-2017')
      )
    end

    it 'links the judges suggested to compare with to the page of the judge when no year is given' do
      get suggest_judges_path(facet: 'name', term: 'zilk', id: dalak.id)

      expect(link('JUDr. Margita Žilková')).to eq(judge_path(dalak, name: 'JUDr. Margita Žilková', l: :sk))
    end
  end
end
