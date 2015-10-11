# encoding: utf-8

require 'spec_helper'

describe JusticeGovSk::Parser::SelectionProcedure do
  let(:parser) { described_class.new }
  let(:document) { parser.parse(load_fixture('justice_gov_sk/selection_procedure.html')) }

  describe '#organization_name' do
    it 'returns name of organization' do
      expect(parser.organization_name(document)).to eql('Okresný súd Košice okolie')
    end
  end

  describe '#organization_name_unprocessed' do
    it 'returns name of organization' do
      expect(parser.organization_name_unprocessed(document)).to eql('Okresný súd Košice okolie')
    end
  end

  describe '#organization_description' do
    it 'returns name of organization' do
      expect(parser.organization_description(document)).to eql('Okresný súd Košice - okolie')
    end
  end

  describe '#position' do
    it 'returns position for selection procedure' do
      expect(parser.position(document)).to eql('Sudca')
    end
  end

  describe '#workplace' do
    it 'returns workplace' do
      expect(parser.workplace(document)).to eql('Okresný súd Košice - okolie, Štúrova č. 29, 041 51 Košice')
    end
  end

  describe '#place' do
    it 'returns place of procedure' do
      expect(parser.place(document)).to eql('Krajský súd Košice, Štúrova č. 29, 041 51 Košice, miestnosť č. 207/2. poschodie - zasadačka')
    end
  end

  describe '#state' do
    it 'returns state of procedure' do
      expect(parser.state(document)).to eql('Výberové konanie prebieha - Termín na prihlásenie už uplynul')
    end
  end

  describe '#date' do
    it 'returns date of procedure' do
      expect(parser.date(document)).to eql(Time.new(2014, 9, 9))
    end
  end

  describe '#closed_at' do
    it 'returns close date of procedure' do
      expect(parser.closed_at(document)).to eql(Time.new(2014, 7, 23))
    end
  end

  describe '#description' do
    it 'returns description of procedure' do
      expect(parser.description(document)).to eql('Výberové konanie sa začne písomnou časťou dňa 9.9.2014 o 8.00 hod. Výberové konanie trvá spravidla tri dni. O priebehu ďalších častí výberového konania budú uchádzači informovaní v priebehu prvého dňa výberového konania.')
    end
  end

  describe '#declaration_url' do
    it 'returns url of procedure declaration' do
      expect(parser.declaration_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fVyberoveKonania%2f1+miesto+sudcu+pre+Okresn%c3%bd+s%c3%bad+Ko%c5%a1ice+-+okolie%2fzru%c5%a1enie+v%c3%bdberov%c3%a9ho+konania.pdf')
    end
  end

  describe '#report_url' do
    it 'returns url of procedure report' do
      expect(parser.report_url(document)).to be_nil
    end
  end

  describe '#commissioners' do
    it 'returns commissioners of procedure' do
      names = parser.commissioners(document).map { |commissioner| commissioner[:name] }

      expect(names).to be_empty
    end
  end

  describe '#candidates_urls' do
    it 'returns urls of candidates' do
      expect(parser.candidates_urls(document)).to eql([
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11888',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11893',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11898',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11903',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11908',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11913',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11918',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11923',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11928',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11933',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11938',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11943',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11948',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11953',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11958',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11963',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11968',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11973',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11978',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11983',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11988',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11993',
         'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11995'
      ])
    end
  end

  context 'when sound record is not present' do
    let(:document) { parser.parse(load_fixture('justice_gov_sk/selection_procedure_without_sound_record.html')) }

    describe '#organization_name' do
      it 'returns name of organization' do
        expect(parser.organization_name(document)).to eql('Okresný súd Košice okolie')
      end
    end

    describe '#organization_name_unprocessed' do
      it 'returns name of organization' do
        expect(parser.organization_name_unprocessed(document)).to eql('Okresný súd Košice okolie')
      end
    end

    describe '#organization_description' do
      it 'returns name of organization' do
        expect(parser.organization_description(document)).to eql('Okresný súd Košice - okolie')
      end
    end

    describe '#position' do
      it 'returns position for selection procedure' do
        expect(parser.position(document)).to eql('Sudca')
      end
    end

    describe '#workplace' do
      it 'returns workplace' do
        expect(parser.workplace(document)).to eql('Okresný súd Košice - okolie, Štúrova č. 29, 041 51 Košice')
      end
    end

    describe '#place' do
      it 'returns place of procedure' do
        expect(parser.place(document)).to eql('Krajský súd Košice, Štúrova č. 29, 041 51 Košice, miestnosť č. 207/2. poschodie - zasadačka')
      end
    end

    describe '#state' do
      it 'returns state of procedure' do
        expect(parser.state(document)).to eql('Aktuálne výberové konanie')
      end
    end

    describe '#date' do
      it 'returns date of procedure' do
        expect(parser.date(document)).to eql(Time.new(2014, 9, 9))
      end
    end

    describe '#closed_at' do
      it 'returns close date of procedure' do
        expect(parser.closed_at(document)).to eql(Time.new(2014, 7, 23))
      end
    end

    describe '#description' do
      it 'returns description of procedure' do
        expect(parser.description(document)).to eql('Výberové konanie sa začne písomnou časťou dňa 9.9.2014 o 8.00 hod. Výberové konanie trvá spravidla tri dni. O priebehu ďalších častí výberového konania budú uchádzači informovaní v priebehu prvého dňa výberového konania.')
      end
    end

    describe '#declaration_url' do
      it 'returns url of procedure declaration' do
        expect(parser.declaration_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fVyberoveKonania%2f1+miesto+sudcu+pre+Okresn%c3%bd+s%c3%bad+Ko%c5%a1ice+-+okolie%2fv%c3%bdberov%c3%a9+konanie.pdf')
      end
    end

    describe '#report_url' do
      it 'returns url of procedure report' do
        expect(parser.report_url(document)).to eql('http://www.justice.gov.sk/Stranky/SuborStiahnut.aspx?Url=%2fVyberoveKonania%2fV%c3%bdberov%c3%a9+konanie+-+2+vo%c4%ben%c3%a9+miesta+sudcov+pre+Okresn%c3%bd+s%c3%bad+Michalovce%2fZ%c3%a1pisnica.pdf')
      end
    end

    describe '#commissioners' do
      it 'returns commissioners of procedure' do
        names = parser.commissioners(document).map { |commissioner| commissioner[:name] }

        expect(names).to eql(['JUDr. Soňa Zmeková', 'JUDr. Roman Greguš', 'JUDr. Lýdia Gálisová', 'JUDr. Rudolf Čirč', 'JUDr. Ondrej Laciak, PhD.'])
      end
    end

    describe '#candidates_urls' do
      it 'returns urls of candidates' do
        expect(parser.candidates_urls(document)).to eql([
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10517',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10774',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10775',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10776',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10777',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10778',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10779',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10780',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10781',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10782',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10783',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10784',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10785',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10786',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10787',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10793',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10794',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10795',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10796',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10797',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10798',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10799',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10800',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10801',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10802',
          'http://www.justice.gov.sk/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=10803'
        ])
      end
    end
  end
end
