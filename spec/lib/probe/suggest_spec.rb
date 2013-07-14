require 'probe_spec_helper'

shared_examples_for Probe::Suggest do
  let!(:options) { model.search_options }

  before :each do
    reload_indices
  end

  after :all do
    delete_indices
  end

  context 'when suggesting facets' do
    it 'should suggest correct values for term' do
      results = model.suggest(suggest, suggest_term, {})

      results.facets[suggest].results.each do |result|
        suggest_term.split(/\s/).each do |term|
          result.value.should include(term)
        end
      end
    end
  end
end
