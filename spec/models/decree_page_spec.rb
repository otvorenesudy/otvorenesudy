# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecreePage do
  describe '.search_pages' do
    let(:decree) { create(:decree) }

    before do
      create(:decree_page, decree:, number: 1, text: 'Okresný súd rozhodol o žalobe.')
      create(:decree_page, decree:, number: 2, text: 'Odôvodnenie: žalobca podal žalobe podobný návrh.')
      create(:decree_page, decree:, number: 3, text: 'Poučenie o opravnom prostriedku.')
      create(:decree_page, decree: create(:decree), number: 1, text: 'Iný súd rozhodol o žalobe.')
      refresh_indices
    end

    it "finds the decree's pages with the text, with their highlighted fragments by number" do
      response, highlights = described_class.search_pages(decree.id, 'žalobe')

      expect(response['hits']['hits'].size).to eq(2)
      expect(highlights.keys).to contain_exactly(1, 2)
      expect(highlights[1]).to eq(['Okresný súd rozhodol o <em>žalobe</em>.'])
    end

    it 'finds no pages for a text the decree does not have' do
      _, highlights = described_class.search_pages(decree.id, 'dovolanie')

      expect(highlights).to be_empty
    end
  end
end
