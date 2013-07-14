require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Judge do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Judge }
      let(:records) { 10.times.map { create :judge }}
      let(:record) { records.first }
      let(:query) { record.first }
      let(:highlight_field) { :name }
      let(:filter) {{ courts: record.courts.pluck(:name) }}
      let(:sort_field) { :name }
      let(:suggest) { :courts }
      let(:suggest_term) { record.courts.first.name.first(3) }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Judge }
      let(:judge)   { create :judge }
      let(:record)  { judge }
      let(:query)   {{ courts: record.courts.pluck(:name) }}
    end
  end
end
