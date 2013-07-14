require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Hearing do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Hearing }
      let(:records) { 10.times.map { create :hearing } }
      let(:record) { records.first }
      let(:query) { record.judges[0].first }
      let(:highlight_field) { :judges }
      let(:filter) {{ judges: [record.judges.pluck(:name)], historical: false }}
      let(:sort_field) { :file_number }
      let(:suggest) { :judges }
      let(:suggest_term) { record.judges.first.name.first(2) }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Hearing }
      let(:record)  { create :hearing }
      let(:query)   {{ judges: record.judges.pluck(:name) }}

      before :each do
        Hearing.facets[:historical].terms = true
      end
    end
  end
end
