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
    elsif value.match(/\AJUDr.\s*[\p{Word}.,\s]+\s{2}JUDr./)
      values = value.split(/\s{2}/)
    else
      replacements = ['PhD', 'CSc', 'LLM-PhD']

      replacements.each do |replacement|
        value.gsub!(/,\s*#{replacement}/i, "-#{replacement}")
      end

      values = value.split(/[;,]/)

      values.map! do |name|
        replacements.each do |replacement|
          name.gsub!(/-#{replacement}/, ", #{replacement}")
        end

        name.strip
      end
    end

    values.map { |name|
      next unless name.present?

      unprocessed = name
      name        = normalize_person_name(name.gsub(/(-.*){0,1}(zvolen[ýá]|menovan[ýá]|späťvzatie|nezúčastní|za\s+).+\z/i, ''))

      next unless name.present?

      { name: name, unprocessed: unprocessed }
    }.compact
  end
end
