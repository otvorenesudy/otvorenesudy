require 'spec_helper'

describe JusticeGovSk::Helper::SelectionProcedure do
  subject { described_class }

  describe '.normalize_position' do
    it 'normalizes position upcasing first letter' do
      expect(subject.normalize_position('hlavný radca-VSÚ')).to eql('Hlavný radca – VSÚ')
    end
  end

  describe '.parse_commissioners' do
    it 'parses commissioners provided as list' do
      value = '1. JUDr. Tibor Kubík 2. JUDr. Ľuboš Sádovský 3. JUDr. Imrich Volkai 4. JUDr. Ingrid Doležajová 5. posledný člen bude zvolený sudcovskou radou'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr. Tibor Kubík', 'JUDr. Ľuboš Sádovský', 'JUDr. Imrich Volkai', 'JUDr. Ingrid Doležajová'])
      expect(names).to eql(['JUDr. Tibor Kubík', 'JUDr. Ľuboš Sádovský', 'JUDr. Imrich Volkai', 'JUDr. Ingrid Doležajová'])
    end

    it 'parses commissioners provided as comma-separated value' do
      value = 'JUDr.Daniel Hudák, JUDr.Ondrej Laciak,PhD.,JUDr.Ľuboš Sádovský, JUDr. Jana Bajánková, JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Daniel Hudák', 'JUDr.Ondrej Laciak, PhD.', 'JUDr.Ľuboš Sádovský', 'JUDr. Jana Bajánková', 'JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'])
      expect(names).to eql(['JUDr. Daniel Hudák', 'JUDr. Ondrej Laciak, PhD.', 'JUDr. Ľuboš Sádovský', 'JUDr. Jana Bajánková', 'JUDr. Nora Vladová'])
    end

    it 'parses commissioners provided as comma-separated value with wrong titles' do
      value = 'doc. JUDr. Milan Ďurica, PhD., JUDr. Marian Török, JUDr. Ing. Ján Gandžala PhD., JUDr. Peter Zachar, JUDr. Ondrej Laciak, Phd.,'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(names).to eql(['doc. JUDr. Milan Ďurica, PhD.', 'JUDr. Marian Török', 'JUDr. Ing. Ján Gandžala, PhD.', 'JUDr. Peter Zachar', 'JUDr. Ondrej Laciak, PhD.'])
      expect(unprocessed).to eql(['doc. JUDr. Milan Ďurica, PhD.', 'JUDr. Marian Török', 'JUDr. Ing. Ján Gandžala PhD.', 'JUDr. Peter Zachar', 'JUDr. Ondrej Laciak, PhD.'])
    end

    it 'parses commissioners with notes' do
      value = 'JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'])
      expect(names).to eql(['JUDr. Nora Vladová'])
    end

    it 'parses commissioners with complex notes' do
      value = 'JUDr. Janka Gažovičová, JUDr. Ľubomír Hudák - zvolený plénom Okresného súdu Malacky, JUDr. Juraj Danko -späťvzatie žiadosti, JUDr. Anna Mýtniková - nezúčastní sa VK, JUDr. Juraj Palko späťvzatie žiadosti, JUDr. Otília Doláková - za sudcovskú radu OS BA I, JUDr. Otília Doláková za sudcovskú radu OS BA I,'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr. Janka Gažovičová', 'JUDr. Ľubomír Hudák - zvolený plénom Okresného súdu Malacky', 'JUDr. Juraj Danko -späťvzatie žiadosti', 'JUDr. Anna Mýtniková - nezúčastní sa VK', 'JUDr. Juraj Palko späťvzatie žiadosti', 'JUDr. Otília Doláková - za sudcovskú radu OS BA I', 'JUDr. Otília Doláková za sudcovskú radu OS BA I'])
      expect(names).to eql(['JUDr. Janka Gažovičová', 'JUDr. Ľubomír Hudák', 'JUDr. Juraj Danko', 'JUDr. Anna Mýtniková', 'JUDr. Juraj Palko', 'JUDr. Otília Doláková', 'JUDr. Otília Doláková'])
    end

    it 'parses commissioners provided as space separated values' do
      value = 'JUDr. Katarína Slováčeková  JUDr. Ján Hrubala  JUDr. Peter Straka  JUDr. Andrej Bartakovič'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr. Katarína Slováčeková', 'JUDr. Ján Hrubala',  'JUDr. Peter Straka', 'JUDr. Andrej Bartakovič'])
      expect(names).to eql(['JUDr. Katarína Slováčeková', 'JUDr. Ján Hrubala',  'JUDr. Peter Straka', 'JUDr. Andrej Bartakovič'])
    end

    it 'parses commissioners provided as dash separated values with base court' do
      pending 'Not Implemented Yet'

      value = 'JUDr.Soňa Zmeková - MS SR  JUDr. Daniel Hudák - MS SR  Mgr. Miroslav Maďar - NR SR  JUDr. Peter Zachar - Súdna rada SR  JUDr. Ľuboš Baka - OS Levice'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Soňa Zmeková - MS SR', 'JUDr. Daniel Hudák - MS SR', 'Mgr. Miroslav Maďar - NR SR', 'JUDr. Peter Zachar - Súdna rada SR', 'JUDr. Ľuboš Baka - OS Levice'])
      expect(names).to eql(['JUDr.Soňa Zmeková', 'JUDr. Daniel Hudák', 'Mgr. Miroslav Maďar', 'JUDr. Peter Zachar', 'JUDr. Ľuboš Baka'])
    end
  end
end
