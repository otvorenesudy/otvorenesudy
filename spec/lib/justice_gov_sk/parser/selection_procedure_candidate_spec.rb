require 'spec_helper'

describe JusticeGovSk::Parser::SelectionProcedureCandidate do
  let(:parser) { described_class.new }
  let(:document) { parser.parse(load_fixture('justice_gov_sk/selection_procedure_candidate.html')) }

  describe '#name' do
    it 'returns name of candidate' do
      expect(parser.name(document)).to eql('Mgr. Zuzana Gašpírová')
    end
  end

  describe '#name_unprocessed' do
    it 'returns unprocessed name of candidate' do
      expect(parser.name_unprocessed(document)).to eql('Mgr. Zuzana Gašpírová')
    end
  end

  describe '#accomplished_expectations' do
    it 'returns accomplished expectations of candidate' do
      expect(parser.accomplished_expectations(document)).to eql('áno')
    end
  end

  describe '#written_score' do
    it 'returns written score of candidate' do
      expect(parser.written_score(document)).to eql('111')
    end
  end

  describe '#written_result' do
    it 'returns written result of candidate' do
      expect(parser.written_result(document)).to eql('uspel')
    end
  end

  describe '#oral_score' do
    it 'returns oral score of candidate' do
      expect(parser.oral_score(document)).to eql('73')
    end
  end

  describe '#oral_result' do
    it 'returns oral result of candidate' do
      expect(parser.oral_result(document)).to eql('uspel')
    end
  end

  describe '#score' do
    it 'returns total score of candidate' do
      expect(parser.score(document)).to eql('184')
    end
  end

  describe '#rank' do
    it 'returns position of candidate in procedure' do
      expect(parser.rank(document)).to eql('3')
    end
  end

  describe '#application_url' do
    it 'returns url of candidate application' do
      expect(parser.application_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fUchadzaci%2fGa%c5%a1p%c3%adrov%c3%a1+Zuzana+Mgr.+Spr.+75_2014%2fMgr.+Zuzana+Ga%c5%a1p%c3%adrov%c3%a1+-+%c5%bdiados%c5%a5.PDF')
    end
  end

  describe '#curriculum_url' do
    it 'returns url of candidate curriculum' do
      expect(parser.curriculum_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fUchadzaci%2fGa%c5%a1p%c3%adrov%c3%a1+Zuzana+Mgr.+Spr.+75_2014%2fMgr.+Zuzana+Ga%c5%a1p%c3%adrov%c3%a1+-+%c5%bdivotopis.PDF')
    end
  end

  describe '#motivation_letter_url' do
    it 'returns url of candidate motivation letter' do
      expect(parser.motivation_letter_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fUchadzaci%2fGa%c5%a1p%c3%adrov%c3%a1+Zuzana+Mgr.+Spr.+75_2014%2fMgr.+Zuzana+Ga%c5%a1p%c3%adrov%c3%a1+-+Motova%c4%8dn%c3%bd+list.PDF')
    end
  end

  describe '#declaration_url' do
    it 'returns candidate declaration' do
      expect(parser.declaration_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fUchadzaci%2fGa%c5%a1p%c3%adrov%c3%a1+Zuzana+Mgr.+Spr.+75_2014%2fMgr.+Zuzana+Ga%c5%a1p%c3%adrov%c3%a1+-+Vyhl%c3%a1senie.PDF')
    end
  end
end
