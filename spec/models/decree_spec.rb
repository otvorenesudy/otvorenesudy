require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Decree do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Decree }
      let(:records) { 10.times.map { create :decree } }
      let(:record) { records.first }
      let(:query) { record.judges[0].first }
      let(:highlight_field) { :judges }
      let(:filter) {{ judges: [record.judges.pluck(:name)] }}
      let(:sort_field) { :ecli }
      let(:suggest) { :judges }
      let(:suggest_term) { record.judges.first.name.first(2) }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Decree }
      let(:record)  { create :decree }
      let(:query)   {{ judges: record.judges.pluck(:name) }}
    end
  end
end
