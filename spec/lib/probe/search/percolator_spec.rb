require 'probe_spec_helper'

shared_examples_for Probe::Search::Percolator do
  let!(:options) { model.search_options }
  let!(:percolator) { Probe::Search::Percolator.new(model, options) }

  before :each do
    record.save

    model.delete_index
    model.update_index
  end

  after :all do
    model.delete_index
  end

  context 'when percolating a document' do
    it 'should match generic match_all percolator' do
      percolator.register('matching_all', {})

      record.percolate.should include('matching_all')

      percolator.unregister('matching_all')
    end

    it 'should match document for registered query' do
      percolator.register('tralala', query)

      record.percolate.should include('tralala')
    end

    it 'should not match document' do
      percolator.unregister('tralala')

      record.percolate.should be_empty
    end
  end
end
