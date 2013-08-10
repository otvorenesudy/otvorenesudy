require 'probe_spec_helper'
require 'lib/probe/facets/facet_spec'

describe Probe::Facets::RangeFacet do
  let(:facet) { Probe::Facets::RangeFacet.new(:range, :field, ranges: [1..2, 2..3]) }

  it_behaves_like Probe::Facets::Facet do
    let(:facet)  { Probe::Facets::RangeFacet.new(:range, :field, ranges: [1..2, 2..3]) }
    let(:params) { 1..2 }
  end

  context 'when parsing terms' do
    it 'should parse data params' do
      facet.parse_terms(2..4).should eql([2..4])
    end

    it 'should correcly parse array' do
      facet.parse_terms([2..4, 4..8]).should eql([2..4, 4..8])
    end

    it 'should parse bogus parms' do
      facet.parse_terms(a: 1).should be_nil
    end
  end

  context 'when creating filter' do
    it 'should create filter' do
      facet.terms = facet.parse_terms(2..5)

      facet.build_filter.should eql(or: [{ range: { facet.field => { gte: 2, lte: 5 } }}])
    end

    it 'should build more complex filter' do
      params = [2..3, 3..5, 5..10]

      facet.terms  = facet.parse_terms(params)
      type, filter = *facet.build_filter.first

      type.should eql(:or)

      filter.each_with_index do |f, i|
        f.should eql(range: { facet.field => { gte: params[i].begin, lte: params[i].end } })
      end

      filter.count.should eql(params.count)
    end
  end

  context 'when building facet' do
    it 'should build facet' do
      facet.build(:name).should eql({ name: { range: { field: facet.field, ranges: [{ to: 1 }, { from: 1, to: 3 }, { from: 2, to: 4 }, { from: 3 }]}}})
    end
  end

  context 'when populating facet' do
    pending
  end
end
