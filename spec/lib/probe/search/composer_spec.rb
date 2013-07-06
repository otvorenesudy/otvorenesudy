require 'probe_spec_helper'

shared_examples_for Probe::Search::Composer do
  let(:composer) { Probe::Search::Composer }
  let!(:options) { model.search_options }

  before :each do
    record.save

    model.delete_index
    model.update_index
  end

  after :all do
    model.delete_index
  end

  context 'when searching by fulltext' do
    it 'should search index by query' do
      options[:params] = { q: query }

      options[:facets] = Probe::Facets.new([
        Probe::Facets::FulltextFacet.new(:q, highlight_field, force_wildcard: false)
      ])

      search  = composer.new(model, options)
      results = search.compose

      results.records.first.should eql(record)
      results.records.size.should eql(1)
      results.highlights.first[highlight_field].join.should include("<em>#{query}</em>")
    end

    it 'should wildcardize query' do
      options[:params] = { q: "*#{query.first}*" }

      options[:facets] = Probe::Facets.new([
        Probe::Facets::FulltextFacet.new(:q, highlight_field, force_wildcard: false)
      ])

      search  = composer.new(model, options)
      results = search.compose

      highlight = results.highlights.first

      highlight[highlight_field].join.should match(/\<em\>.*#{query.first}.*\<\/em\>/)
    end
  end

  context 'when searching by filter' do
    it 'should search index by one value' do
      name, value = filter.first

      options[:params] = { name => value }

      options[:facets] = Probe::Facets.new(model.facets[name])

      search  = composer.new(model, options)
      results = search.compose

      results.facets[name].results.each do |result|
        add_params    = Array.wrap(value) + [result.value]
        remove_params = Array.wrap(value) - [result.value]

        result.params[name].should eql(add_params.uniq)
        result.add_params[name].should eql(add_params.uniq)
        result.remove_params[name].should eql(remove_params.uniq)
      end
    end
  end
end
