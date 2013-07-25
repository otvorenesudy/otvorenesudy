require 'probe_spec_helper'

describe Probe::Search::Composer do
  let(:params)  { Hash.new.with_indifferent_access }
  let(:options) { { name: 'example' } }

  it 'should compose query from facets' do
    facets = Probe::Facets.new([
      Probe::Facets::FulltextFacet.new(:q, :all, Hash.new),
      Probe::Facets::TermsFacet.new(:term, :term, Hash.new)
    ])

    params[:q]    = 'q'
    params[:term] = 'attribute'

    options.merge! facets: facets, params: params

    search = Probe::Search::Composer.new(nil, options)

    query = search.compose_search(Hash.new)

    query[:query][:bool][:must].first.should eql(facets[:q].build_query)
    query[:filter][:and].first[:or].should   eql(facets[:term].build_filter)

    query[:facets].each do |name, options|
      facet = facets[name.to_s.gsub(/_selected\z/, '').to_sym]

      if name =~ /_selected\z/
        options[:facet_filter].should be_nil

        facet.build(facet.selected_name, global: false).should eql(name => options)
      else
        options[:facet_filter].should_not be_nil if facet.params.any?

        facet.build(name, global: true, facet_filter: options[:facet_filter]).should eql(name => options)
      end
    end
  end
end
