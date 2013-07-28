require 'probe_spec_helper'
require 'lib/probe/facets/facet_spec'

describe Probe::Facets::RangeFacet do
  let(:facet) { Probe::Facets::RangeFacet.new(:range, :field, ranges: [1..2, 2..3]) }

  it_behaves_like Probe::Facets::Facet do
    let(:facet)  { Probe::Facets::RangeFacet.new(:range, :field, ranges: [1..2, 2..3]) }
    let(:params) { Date.today..Date.tomorrow }
  end
end
