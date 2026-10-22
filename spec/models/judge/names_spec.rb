# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Judge::Names do
  describe '.of' do
    let(:hearing) { create(:hearing) }

    before do
      create(:judging, hearing:, judge: create(:judge, first: 'Eva', last: 'Malá'))
      create(:judging, hearing:, judge_name_similarity: 0.7, judge_name_unprocessed: 'JUDr. NOVÁK Ján, PhD.')
      create(:judging, hearing:, judge_name_similarity: 0.6, judge_name_unprocessed: 'JUDr. Ján NOVÁK, PhD.')
    end

    it "names the hearing's judges: the matched ones, then the others as the source wrote them, normalized" do
      expect(described_class.of(hearing.judges)).to eq(['JUDr. Eva Malá', 'JUDr. Ján Novák, PhD.'])
    end

    it 'names them from the judgings as well' do
      expect(described_class.of(hearing.judgings)).to eq(['JUDr. Eva Malá', 'JUDr. Ján Novák, PhD.'])
    end
  end
end
