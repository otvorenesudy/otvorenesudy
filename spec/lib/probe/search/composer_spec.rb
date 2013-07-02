require 'probe_spec_helper'

shared_examples_for Probe::Search::Composer do
  let(:composer) { Probe::Search::Composer }
  let!(:options) { Hash.new.with_indifferent_access }

  context 'when searching by fulltext' do
    before :each do
      options[:name]        = model.index.name
      options[:facets]      = model.facets
      options[:sort_fields] = model.sort_fields
      options[:per_page]    = model.per_page
    end

    it 'should search index by query' do
      options[:params] = { q: query }

      search = composer.new(model, options)

      results = search.compose

      results.records.size.should eql(1)
      results.records.first.should eql(instance)
      results.highlights.first.values.to_s.should include("<em>#{query}</em>")
    end

    it 'should wildcardize query' do
      options[:params] = { q: "*a*" }

      search = composer.new(model, options)

      results = search.compose

      results.highlights.each do |highlight|
        highlight.values.to_s.should include("<em>a</em>")
      end
    end

    it 'should search by exact query' do
      options[:params] = { q: "#{exact_query}" }

      search = composer.new(model, options)

      results = search.compose

      results.highlights.each do |highlight|
        highlight.values.to_s.should include("<em>#{exact_query}</em>")
      end
    end
  end
end
