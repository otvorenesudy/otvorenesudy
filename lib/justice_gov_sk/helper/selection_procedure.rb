module JusticeGovSk::Helper::SelectionProcedure
  include JusticeGovSk::Helper::Normalizer
  extend  self

  def normalize_position(value)
    value.upcase_first.gsub(/\s*-\s*/, ' – ')
  end

  def parse_commissioners(value)
    if value.match(/\d+\./)
      values = value.split(/\d+\./).map { |name|
        name = name.strip

        next if name.blank? || name =~ /posledný člen bude zvolený sudcovskou radou/i

        name.strip
      }.compact
    else
      replacements = ['PhD', 'CSc']

      replacements.each do |replacement|
        value.gsub!(/,\s*#{replacement}/, "-#{replacement}")
      end

      values = value.split(/[;,]/)

      values.map! do |name|
        replacements.each do |replacement|
          name.gsub!(/-#{replacement}/, ", #{replacement}")
        end

        name.strip
      end
    end

    values.map do |name|
      unprocessed = name
      name        = normalize_person_name(name.gsub(/-.*zvolen[ýá] .+\z/i, ''))

      { name: name, unprocessed: unprocessed }
    end
  end
end
