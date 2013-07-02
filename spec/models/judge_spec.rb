require 'spec_helper'
require 'lib/probe/search/composer_spec'

describe Judge do
  describe 'search' do
    it_behaves_like Probe::Search::Composer do
      let(:model) { Judge }
      let(:judge) { create :judge }
      let(:instance) { judge }
      let(:query) { judge.first }
      let(:exact_query) { judge.name }
    end
  end
end
