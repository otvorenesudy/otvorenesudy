require 'probe_spec_helper'
require 'lib/probe/facets/facet_spec'

describe Probe::Facets::FulltextFacet do
  let(:facet) { Probe::Facets::FulltextFacet.new(:q, :all, Hash.new) }

  context 'when parsing terms' do
    it 'should parse simple params' do
      facet.parse_terms('blabla').should eql('blabla')
    end

    it 'should parse array params' do
      facet.parse_terms(['a','b']).should eql('a b')
    end

    it 'should not parse empty params' do
      facet.parse_terms('').should be_nil
    end

    it 'should not parse nil value' do
      facet.parse_terms(nil).should be_nil
    end
  end

  context 'when building query' do
    it 'should build query with simple params' do
      facet.terms = 'blabla'

      facet.build_query.should eql(must: {
        query_string: {
          query: 'blabla',
          fields: [:'*.analyzed'],
          default_operator: :or,
          analyze_wildcard: true
        }
      })
    end

    it 'should build query with forced wildcard' do
      facet.terms = 'blabla b'

      facet.force_wildcard = true

      facet.build_query.should eql(must: {
        query_string: {
          query: 'blabla* b*',
          fields: [:"*.analyzed"],
          default_operator: :or,
          analyze_wildcard: true
        }
      })
    end
  end

  # TODO: highlights
end
