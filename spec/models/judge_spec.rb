require 'spec_helper'
require 'lib/probe/search/composer_spec'
require 'lib/probe/search/percolator_spec'

describe Judge do
  describe 'search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Judge }
      let(:judge) { create :judge }
      let(:record) { judge }
      let(:query) { judge.first }
      let(:exact_query) { judge.name }
    end

    it_behaves_like Probe::Search::Percolator do
      let(:model) { Judge }
      let(:judge) { create :judge }
      let(:record) { judge }
      let(:query) { { court: judge.employments.first.court.name }}
    end
  end
end
