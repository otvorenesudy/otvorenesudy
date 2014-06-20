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
      expect(parser.declaration_url(document)).to eql('/Stranky/SuborStiahnut.aspx?Url=%2fVyberoveKonania%2f1+miesto+sudcu+pre+Okresn%c3%bd+s%c3%bad+Ko%c5%a1ice+-+okolie%2fv%c3%bdberov%c3%a9+konanie.pdf')
    end
  end

  describe '#report_url' do
    it 'returns url of procedure report' do
      expect(parser.report_url(document)).to eql('/Stranky/SuborStiahnut.aspx?Url=%2fVyberoveKonania%2fV%c3%bdberov%c3%a9+konanie+-+2+vo%c4%ben%c3%a9+miesta+sudcov+pre+Okresn%c3%bd+s%c3%bad+Michalovce%2fZ%c3%a1pisnica.pdf')
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
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11392',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11397',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11402',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11407',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11412',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11417',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11422',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11427',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11432',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11437',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11442',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11447',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11452',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11457',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11462',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11467',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11472',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11477',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11482',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11487',
       '/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Detail-uchadzaca-vyberoveho-konania.aspx?Ic=11492'
      ])
    end
  end
end

describe JusticeGovSk::Parser::SelectionProcedure::CommissionersParser do
  let(:parser) { described_class }

  describe '.parse' do
    it 'parses commissioners provided as list' do
      value = '1. JUDr. Tibor Kubík 2. JUDr. Ľuboš Sádovský 3. JUDr. Imrich Volkai 4. JUDr. Ingrid Doležajová 5. posledný člen bude zvolený sudcovskou radou'

      names = parser.parse(value).map { |name| name[:name] }
      unprocessed = parser.parse(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr. Tibor Kubík', 'JUDr. Ľuboš Sádovský', 'JUDr. Imrich Volkai', 'JUDr. Ingrid Doležajová'])
      expect(names).to eql(['JUDr. Tibor Kubík', 'JUDr. Ľuboš Sádovský', 'JUDr. Imrich Volkai', 'JUDr. Ingrid Doležajová'])
    end

    it 'parses commissioners provided as comma-separated value' do
      value = 'JUDr.Daniel Hudák, JUDr.Ondrej Laciak,PhD.,JUDr.Ľuboš Sádovský, JUDr. Jana Bajánková, JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'

      names = parser.parse(value).map { |name| name[:name] }
      unprocessed = parser.parse(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Daniel Hudák', 'JUDr.Ondrej Laciak, PhD.', 'JUDr.Ľuboš Sádovský', 'JUDr. Jana Bajánková', 'JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'])
      expect(names).to eql(['JUDr. Daniel Hudák', 'JUDr. Ondrej Laciak, PhD.', 'JUDr. Ľuboš Sádovský', 'JUDr. Jana Bajánková', 'JUDr. Nora Vladová'])
    end

    it 'parses commissioners with notes' do
      value = 'JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'

      names = parser.parse(value).map { |name| name[:name] }
      unprocessed = parser.parse(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'])
      expect(names).to eql(['JUDr. Nora Vladová'])
    end
  end
end
