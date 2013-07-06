require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Judge do
  describe 'search' do
    it_behaves_like Probe::Search::Composer do
      let(:model)  { Judge }
      let(:judge)  { create :judge }
      let(:record) { judge }
      let(:query)  { record.first }
      let(:highlight_field) { :name }
      let(:filter) {{ courts: record.courts.pluck(:name) }}
    end

    it_behaves_like Probe::Search::Percolator do
      let(:model)   { Judge }
      let(:judge)   { create :judge }
      let(:record)  { judge }
      let(:query)   {{ courts: record.courts.pluck(:name) }}
    end
  end
end
