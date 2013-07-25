# encoding: utf-8

module SudnaradaGovSk
  class Parser
    class JudgePropertyDeclaration < SudnaradaGovSk::Parser
      def year(document)
        find_value 'year', document, 'h2.sudca' do |h2|
          h2.text.match(/\d+\z/)[0]
        end
      end

      def judge(document)
        find_value 'judge', document, 'h1.sudca', verbose: false do |h1|
          partition_person_name(normalize_name h1.text)
        end
      end

      def property_lists(document)
        find_values 'property lists', document, 'h4 + table.table_list', verbose: false do |tables|
          categories = document.search('h4').select { |h4| h4.next && h4.next.next && h4.next.next.node_name == 'table' }
          lists      = []

          tables.each_with_index do |table, i|
            properties = []

            table.search('tr[class^=tab]').each do |row|
              properties << {
                description:        normalize_value(row.search('td.nazov').text),
                acquisition_reason: normalize_value(row.search('td.dovod').text),
                acquisition_date:   normalize_value(row.search('td.datum').text),
                cost:               normalize_value(row.search('td.cena').text.gsub(/\s+/, '')),
                ownership_form:     normalize_value(row.search('td.vlast').text),
                share_size:         normalize_value(row.search('td.podiel').text),
                change:             normalize_value(row.search('td.zmena').text)
              }
            end

            lists << { category: categories[i].text.strip, properties: properties }
          end

          lists
        end
      end

      def incomes(document)
        find_values 'incomes', document, 'table td.nazov3', verbose: false do |cells|
          values  = document.search('table td.zarobok')
          incomes = []

          cells.each_with_index do |cell, i|
            next if cell.text.blank?
            incomes << { description: cell.text.strip, value: values[i].text.gsub(/\s+/, '').gsub(/\,/, '.').to_f }
          end

          incomes
        end
      end

      def related_people(document)
        find_values 'related people', document, 'tr#tr_osoby tr[class^=tab]', verbose: false do |rows|
          rows.map { |row|
            next unless person = row.search('td.nazov')[0]

            {
              name:        partition_person_name(normalize_related_person_name(person.text), reverse: true),
              institution: normalize_institution(row.search('td.instit')[0].text),
              function:    normalize_function(row.search('td.zmena')[0].text)
            }
          }.reject { |row| row.blank? }
        end
      end

      def statements(document)
        find_values 'statements', document, 'table.vyhlasenia tr', verbose: false do |rows|
          statements = []

          rows.reject { |row| ['hide', 'tab0', 'tab1'].include? row[:class] }.each do |row|
            next if row.search('td')[0][:colspan]
            statements << row.search('td')[0].text.strip
          end

          statements
        end
      end

      private

      def normalize_value(value)
        value.strip!

        value unless value =~ /\A(\-|\'\')\z/
      end

      def normalize_name(value)
        value.squeeze!(' ')
        value.gsub!(/\sx+/i, '')

        value.utf8.gsub(/(\s[\S\.\,]){2,}/) { |s| ' ' + s.gsub(/\s/, '') }
      end

      def normalize_related_person_name(value)
        value = value.utf8

        value.gsub!(/[[:space:]]/, ' ')
        value.gsub!(/Okresný\s+súd\s+Bratislava\s+(I\s+)?vyšší\s+súdny\s+úradník/i, '')
        value.gsub!(/Manžel/i, '')
        value.gsub!(/Švagrina/i, '')
      end

      def normalize_institution(value)
        return unless value = normalize_value(value)

        value = normalize_court_name(value)

        value.gsub!(/(U|Ú)VTOS/i, 'ÚVTOS')
        value.gsub!(/Ún?VV/i, 'ÚVV')
        value.gsub!(/ÚZVJS/i, 'ÚZVJS')

        value.gsub!(/financií/i, 'financií')
        value.gsub!(/justičnej/i, 'justičnej')
        value.gsub!(/obvinených/i, 'obvinených')
        value.gsub!(/odsúdených/i, 'odsúdených')
        value.gsub!(/pokladňa/i, 'pokladňa')
        value.gsub!(/prokuratúra/i, 'prokuratúra')
        value.gsub!(/spravodlivosti/i, 'spravodlivosti')
        value.gsub!(/stráže/i, 'stráže')
        value.gsub!(/väzenskej/i, 'väzenskej')

        value
      end

      def normalize_function(value)
        return unless value = normalize_value(value)

        value = value.utf8

        value.gsub!(/súdkyňa/, 'sudkyňa')
        value.gsub!(/asistenka/, 'asistentka')        
        value.gsub!(/probačnýa\s*mediač\.+\s*prac\.+/i, 'probačný a mediačný pracovník')
        value.gsub!(/administr\./i, 'administratívny ')
        value.gsub!(/VS(Ú|U)/i, 'vyšší súdny úradník')
        value.gsub!(/\-bez\s*zaradenia\-MD/i, 'bez zaradenia')

        value = normalize_punctuation(value)

        value.gsub!(/\s*-\s*/, ' – ')

        value.downcase_first
      end

      # TODO impossible to implement normalization of acquisition date on current data
      # TODO rm, unused

      def normalize_acquisition_date(value)
        value = value.ascii.strip

        value.gsub!(/stav\s+k/i, '')
        value.gsub!(/rok/i, '')
        value.gsub!(/r\./i, '')
        value.strip!

        return nil if value == '-'

        puts "VALUE #{value}" #TODO rm

        case
        when value =~ /\./
          parts = value.split(/\./)
          puts "-. #{parts}" #TODO rm
        when value =~ /\//
          parts = value.split(/\//)

          puts "-/ #{parts}" #TODO rm
        when value =~ /[a-z]/
          months = ['januar', 'februar', 'marec', 'april', 'maj', 'jun', 'jul', 'august', 'september', 'oktober', 'november', 'december']
          parts  = [months.index(value.match(/[a-z]+/)[0]) + 1, value.match(/\d+\z/)[0]]

          puts "az #{parts}" #TODO rm
        else
          parts = [value.to_i]
          puts "el !#{parts}" #TODO rm
        end

        year  = parts.last
        month = parts[-2] || 1
        day   = parts[-3] || 1

        "#{'%04d' % year.to_i}-#{'%02d' % month.to_i}-#{'%02d' % day.to_i}"
      end
    end
  end
end
