require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Court do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Court }
      let(:records) { 10.times.map { create :court }}
      let(:record) { records.first }
      let(:query) { record.name.split(/\s/).first }
      let(:highlight_field) { :name }
      let(:filter) {{ municipality: [record.municipality.name] }}
      let(:sort_field) { :municipality }
      let(:suggest) { :municipality }
      let(:suggest_term) { record.municipality.name.first(2) }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Court }
      let(:record)  { create :court }
      let(:query)   {{ judges: record.judges.pluck(:name) }}
    end
  end
end
