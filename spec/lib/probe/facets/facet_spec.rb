require 'probe_spec_helper'

shared_examples_for Probe::Facets::Facet do
  context 'when parsing terms' do
    it 'should not parse empty params' do
      facet.parse_terms('').should be_nil
    end

    it 'should not parse nil value' do
      facet.parse_terms(nil).should be_nil
    end
  end

  context 'when adding terms' do
    it 'should add facet terms' do
      facet.terms = facet.parse_terms(params)

      facet.should       be_active
      facet.terms.should be_present
    end
  end

  context 'when refreshing facet' do
    it 'should refresh facet' do
      facet.refresh!

      facet.terms.should   be_empty
      facet.results.should be_empty
    end
  end
end
