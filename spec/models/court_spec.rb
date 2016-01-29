require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'
require 'lib/probe/suggest_spec'

describe Court do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Court }
      let!(:records) { @records ||= 10.times.map { create :court, :with_employments } }
      let(:record) { records.first }
      let(:query) { record.name.split(/\s/).first }
      let(:highlight_field) { :name }
      let(:filter) {{ municipality: [record.municipality.name, records.second.municipality.name] }}
      let(:sort_field) { :municipality }
      let(:associations) { [:decrees, :municipality] }
    end
  end

  describe '#suggest' do
    it_behaves_like Probe::Suggest do
      let(:model)   { Court }
      let!(:record) { create :court }
      let(:suggest) { :municipality }
      let(:suggest_term) { record.municipality.name.first(2) }
    end
  end
end
