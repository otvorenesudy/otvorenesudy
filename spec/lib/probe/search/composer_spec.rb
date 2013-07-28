require 'probe_spec_helper'

describe Probe::Search::Composer do
  let(:params)  { Hash.new.with_indifferent_access }
  let(:options) { Hash.new }

  before :each do
    Record.class_eval { include Probe }

    options.merge! name: Record.probe.name, facets: Probe::Facets.new
  end

  it 'should compose match_all query' do
    search = Probe::Search::Composer.new(Record.probe, Hash.new)

    query = search.compose_search(Hash.new) { match_all }

    query.should eql({ query: { match_all: {} } })
  end

  it 'should compose filtered query' do
    Record.probe.facets do
      facet :q,    type: :fulltext
      facet :term, type: :terms
    end

    params[:q]    = 'q'
    params[:term] = 'attribute'

    search = Probe::Search::Composer.new(Record.probe, params)

    query = search.compose_search(Hash.new) { compose_filtered_query }

    query = query[:query][:filtered]

    query[:query][:bool].should       eql(facets[:q].build_query)
    query[:filter][:and].first.should eql(facets[:term].build_filter)
  end

  it 'should compose query from facets' do
    Record.probe.facets do
      facet :q,    type: :fulltext
      facet :term, type: :terms
    end

    params[:q]    = 'q'
    params[:term] = 'attribute'

    search = Probe::Search::Composer.new(Record.probe, params)

    query = search.compose_search(Hash.new)

    query[:query][:bool].should       eql(facets[:q].build_query)
    query[:filter][:and].first.should eql(facets[:term].build_filter)

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
