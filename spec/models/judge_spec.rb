require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'
require 'lib/probe/suggest_spec'

describe Judge do
  describe '#search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Judge }
      let!(:records) { @records ||= 10.times.map { create :judge, :with_employments }}
      let(:record) { records.first }
      let(:query) { record.first }
      let(:highlight_field) { :name }
      let(:filter) {{ courts: record.courts.pluck(:name) }}
      let(:sort_field) { :name }
    end
  end

  describe '#suggest' do
    it_behaves_like Probe::Suggest do
      let(:model) { Judge }
      let!(:record)  { create :judge, :with_employments }
      let(:suggest) { :courts }
      let(:suggest_term) { record.courts.first.name.first(3) }
    end
  end
end
