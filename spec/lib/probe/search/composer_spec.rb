require 'probe_spec_helper'

shared_examples_for Probe::Search::Composer do
  let(:composer) { Probe::Search::Composer }
  let!(:options) { model.search_options }

  before :each do
    record.update_index
  end

  context 'when searching by fulltext' do
    it 'should search index by query' do
      options[:params] = { q: query }

      search = composer.new(model, options)

      results = search.compose

      results.records.size.should eql(1)
      results.records.first.should eql(record)
      results.highlights.first.values.to_s.should include("<em>#{query}</em>")
    end

    it 'should wildcardize query' do
      options[:params] = { q: "*#{query.first}*" }

      search = composer.new(model, options)

      results = search.compose

      results.highlights.each do |highlight|
        highlight.values.to_s.should match(/\<em\>.*#{query.first}.*\<\/em\>/)
      end
    end

    it 'should search by exact query' do
      options[:params] = { q: "\"#{exact_query}\"" }

      search = composer.new(model, options)

      results = search.compose

      results.records.size.should eql(1)
    end
  end
end
