require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'
require 'lib/probe/suggest_spec'

describe Hearing do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Hearing }
      let!(:records) { @records ||= 10.times.map { create :hearing } }
      let(:record) { records.first }
      let(:query) { record.judges[0].first }
      let(:highlight_field) { :judges }
      let(:filter) {{ judges: [record.judges.pluck(:name).first, records[1].judges.pluck(:name).second], historical: false }}
      let(:sort_field) { :file_number }
    end
  end

  describe '#percolate' do
    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Hearing }
      let!(:record) { create :hearing, date: 2.years.from_now }
      let(:query)   {{ judges: record.judges.pluck(:name) }}
    end
  end

  describe '#suggest' do
    it_behaves_like Probe::Suggest do
      let(:model)   { Hearing }
      let!(:record) { create :hearing, date: 2.years.from_now }
      let(:suggest) { :judges }
      let(:suggest_term) { record.judges.first.name.first(2) }
    end
  end
end
