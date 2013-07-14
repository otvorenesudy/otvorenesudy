require 'probe_spec_helper'

shared_examples_for Probe::Search::Composer do
  let(:composer) { Probe::Search::Composer }
  let!(:options) { model.search_options }

  before :each do
    record.save!

    reload_indices
  end

  after :each do
    delete_indices
  end

  context 'when searching by fulltext' do
    it 'should search index by query' do
      options[:params] = { q: query }

      options[:facets] = Probe::Facets.new([
        Probe::Facets::FulltextFacet.new(:q, highlight_field, force_wildcard: false)
      ])

      search  = composer.new(model, options)
      results = search.compose

      highlights = results.highlights

      query_highlights = query.split(/\s/).map { |e| "<em>#{e}</em>" }

      highlights.each do |highlight|
        highlight = highlight[highlight_field].join(' ').split(/\s/)

        (highlight& query_highlights).size.should_not be_zero
      end
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
    # TODO: write some examples for range and date filters

    it 'should search index by filter' do
      name, values = filter.first

      options[:params] = { name => values }

      options[:facets] = Probe::Facets.new(model.facets[name])

      search  = composer.new(model, options)
      results = search.compose

      facet = results.facets[name]

      facet.terms.should  eql(values)

      facet.results.each do |result|
        add_params    = Array.wrap(values) + [result.value]
        remove_params = Array.wrap(values) - [result.value]

        result.params.should        eql(name.to_s => add_params.uniq)
        result.add_params.should    eql(name.to_s => add_params.uniq)
        result.remove_params.should eql(name.to_s => remove_params.uniq)
      end
    end
  end

  context 'when sorting results' do
    it 'should sort results by field in descending order' do
      options[:facets]      = Probe::Facets.new([])
      options[:params]      = { sort: sort_field, order: :desc }
      options[:sort_fields] = [sort_field]

      search   = composer.new(model, options)
      response = search.compose

      results = response.results.results

      sorted_results = results.sort_by { |e| e.send(sort_field) }.reverse

      results.should eql(sorted_results)
    end

    it 'should allow only sorting by specific field' do
      options[:facets]      = Probe::Facets.new([])
      options[:sort_fields] = [sort_field]

      results = composer.new(model, options).compose

      options[:params] = { sort: :blabla }

      search        = composer.new(model, options)
      other_results = search.compose

      other_results.records.should eql(results.records)
    end
  end
end
