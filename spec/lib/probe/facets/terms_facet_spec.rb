require 'probe_spec_helper'
require 'lib/probe/facets/facet_spec'

describe Probe::Facets::TermsFacet do
  let(:facet) { Probe::Facets::TermsFacet.new(:term, :term, Hash.new) }

  it_behaves_like Probe::Facets::Facet do
    let(:facet)  { Probe::Facets::TermsFacet.new(:term, :term, Hash.new) }
    let(:params) { 'a' }
  end

  context 'when parsing terms' do
    it 'should parse simple params' do
      facet.parse_terms('a').should eql(['a'])
    end

    it 'should parse array params' do
      facet.parse_terms(['a', 'b']).should eql(['a', 'b'])
    end

    it 'should correctly handle hash values as params' do
      facet.parse_terms(a: :b).should eql(['{:a=>:b}'])
    end
  end

  context 'when creating query' do
    it 'should not create query when suggest term is not present' do
      facet.query = nil

      facet.build_query.should be_nil
    end

    it 'should create suggest query' do
      facet.query = 'a'

      facet.build_query.should eql({ must: {
        query_string: {
          query: 'a*',
          default_operator: :and,
          fields: [facet.field],
          analyze_wildcard: true
          }
       }
      })
    end
  end

  context 'when creating filter' do
    it 'should create filter from simple params' do
      facet.terms = facet.parse_terms('a')

      facet.build_filter.should eql(or: [{ term: { facet.send(:untouched_field) => 'a' } }])
    end

    it 'should build more complex filter' do
      params = ['a', 'b', 'c']

      facet.terms  = facet.parse_terms(params)
      type, filter = *facet.build_filter.first

      type.should eql(:or)

      filter.each_with_index do |f, i|
        f.should eql(term: { facet.send(:untouched_field) => params[i] })
      end

      filter.count.should eql(params.count)
    end
  end

  context 'when building facet' do
    it 'should build facet' do
      facet.build(:name).should eql({ name: { terms: { field: facet.send(:untouched_field), size: facet.size }}})
    end
  end

  context 'when populating facet' do
    it 'should populate facet values from results' do
      facet.terms  = facet.parse_terms(['a', 'c'])
      facet.params = { facet.name => facet.terms }

      results  = { terms: [{ term: 'a', count: 15 }, { term: 'b', count: 12 }], missing: 1}
      selected = { terms: [{ term: 'a', count: 11 }, { term: 'c', count:  3 }], missing: 0}

      facet.populate(results.with_indifferent_access, selected.with_indifferent_access)

      results = facet.results

      results[0].value.should    eql('c')
      results[0].count.should    eql(3)
      results[0].selected.should be_true

      results[1].value.should    eql('a')
      results[1].count.should    eql(15)
      results[1].selected.should be_true

      results[2].value.should    eql('b')
      results[2].count.should    eql(12)
      results[2].selected.should be_false

      results[3].value.should    eql(facet.missing_facet_name)
      results[3].count.should    eql(1)
      results[3].selected.should be_false

      results[1].params.should        eql(facet.name => ['a','c'])
      results[1].add_params.should    eql(facet.name => ['a','c'])
      results[1].remove_params.should eql(facet.name => ['c'])

      results[3].params.should        eql(facet.name => ['a', 'c', 'missing'])
      results[3].add_params.should    eql(facet.name => ['a', 'c', 'missing'])
      results[3].remove_params.should eql(facet.name => ['a', 'c'])
    end
  end
end 
