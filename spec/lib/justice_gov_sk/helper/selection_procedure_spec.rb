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

    it 'parses commissioners with notes' do
      value = 'JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr.Nora Vladová-členka zvolená sudcovskou radou pri Okresnom súde Bratislava II'])
      expect(names).to eql(['JUDr. Nora Vladová'])
    end

    it 'parses commissioners with complex notes' do
      value = 'JUDr. Janka Gažovičová, JUDr. Tibor Kubík, JUDr. Ondrej Laciak, PhD., JUDr. Jaroslav Chlebovič, JUDr. Ľubomír Hudák - zvolený plénom Okresného súdu Malacky'

      names = subject.parse_commissioners(value).map { |name| name[:name] }
      unprocessed = subject.parse_commissioners(value).map { |name| name[:unprocessed] }

      expect(unprocessed).to eql(['JUDr. Janka Gažovičová', 'JUDr. Tibor Kubík', 'JUDr. Ondrej Laciak, PhD.', 'JUDr. Jaroslav Chlebovič', 'JUDr. Ľubomír Hudák - zvolený plénom Okresného súdu Malacky'])
      expect(names).to eql(['JUDr. Janka Gažovičová', 'JUDr. Tibor Kubík', 'JUDr. Ondrej Laciak, PhD.', 'JUDr. Jaroslav Chlebovič', 'JUDr. Ľubomír Hudák'])
    end
  end
end
