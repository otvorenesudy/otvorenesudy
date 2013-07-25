require 'probe_spec_helper'

shared_examples_for Probe::Percolate do
  let!(:options) { model.search_options }
  let!(:percolator) { Probe::Search::Percolator.new(model, options) }

  before :each do
    record.save

    Probe::SpecHelper.reload_indices
  end

  after :all do
    Probe::SpecHelper.delete_indices
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

      record.percolate.should eql([])
    end
  end
end
