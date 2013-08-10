require 'probe_spec_helper'
require 'lib/probe/facets/facet_spec'

describe Probe::Facets::DateFacet do
  let(:facet) { Probe::Facets::DateFacet.new(:date, :date, interval: :month) }

  it_behaves_like Probe::Facets::Facet do
    let(:facet) { Probe::Facets::DateFacet.new(:date, :date, interval: :month) }
    let(:params) { Date.today.to_s..Date.tomorrow.to_s }
  end

  context 'when parsing terms' do
    it 'should parse simple params' do
      facet.parse_terms("#{Date.today.to_s}..#{Date.tomorrow.to_s}").should eql([Date.today..Date.tomorrow])
    end

    it 'should not parse bogus params' do
      facet.parse_terms(a: 1).should be_nil
    end
  end

  context 'when creating filter' do
    it 'should create filter' do
      params = [Date.today.beginning_of_month..Date.today.end_of_month]

      facet.terms = facet.parse_terms(params)

      type, filter = *facet.build_filter.first

      type.should   eql(:or)
      filter.should eql([range: { facet.field => { gte: params.first.begin.to_time, lte: params.first.end.to_time.end_of_day } }])
    end
  end

  context 'when building facet' do
    it 'should build facet' do
      facet.build(:name).should eql(name: { date_histogram: { field: facet.field, interval: :month }})
    end

  end
end
