require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'
require 'lib/probe/suggest_spec'

describe Decree do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Decree }

      let!(:records) { @records ||= 10.times.map { create :decree } }
      let(:record) { records.first }
      let(:query) { record.judges[0].first }
      let(:highlight_field) { :judges }
      let(:filter) {{ judges: [record.judges.pluck(:name)] }}
      let(:sort_field) { :ecli }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Decree }
      let!(:record)  { create :decree }
      let(:query)   {{ judges: record.judges.pluck(:name) }}
    end
  end

  describe '#suggest' do
    it_behaves_like Probe::Suggest do
      let(:model) { Decree }
      let!(:record)  { create :decree }
      let(:suggest) { :judges }
      let(:suggest_term) { record.judges.first.name.first(2) }
    end
  end
end
