require 'probe_spec_helper'

describe Probe::Facets do
  let!(:facets) do 
    Probe::Facets.new([
      Probe::Facets::FulltextFacet.new(:q, :all, Hash.new),
      Probe::Facets::FulltextFacet.new(:wildcarded, :field, force_wildcard: true),
      Probe::Facets::TermsFacet.new(:term, :term, Hash.new)
    ])
  end

  context 'when extracting params' do
    it 'should extract only valid facets params' do
      params = { q: 'a', term: ['b'], bogus: 'blabla' }.with_indifferent_access

      facets.extract_facets_params(params)

      facets.params.should eql(params.except(:bogus))
    end

    it 'should extract only valid search params' do
      params = { q: 'a', term: ['b'], bogus: 'blabla', sort: :date, order: :desc }.with_indifferent_access

      facets.extract_facets_params(params)
      facets.add_search_params(params)

      facets.params.should       eql(params.except(:bogus))
      facets.query_params.should eql(params.except(:bogus, :sort, :order))
    end
  end

  context 'when building query' do
    it 'should build query from facets' do
      facets.extract_facets_params(q: 'a b', wildcarded: 'c d e')

      query = facets.build_query

      query[:must].first.should  eql(facets[:q].build_query[:must])
      query[:must].second.should eql(facets[:wildcarded].build_query[:must])
    end

    it 'should build filter from facets' do
      params = ['a', 'b', 'c']

      facets.extract_facets_params(term: params)

      filter = facets.build_filter :and

      filter[:and].first.should eql(facets[:term].build_filter)
    end

    it 'should build filter for facet' do
      params = { q: 'a', term: ['b'], bogus: 'blabla', sort: :date, order: :desc }.with_indifferent_access

      filter = facets.build_facet_filter(:and, facets[:term])
    end
  end
end

