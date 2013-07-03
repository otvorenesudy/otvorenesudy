# encoding: utf-8

module JusticeGovSk
  module Helper
    module Normalizer
      def normalize_court_name(value)
        value = value.utf8
        
        value.gsub!(/[\-\,]/, '')
        
        value.gsub!(/1/, ' I ')
        value.gsub!(/2/, ' II ')
        value.gsub!(/3/, ' III ')
        value.gsub!(/4/, ' IV ')
        value.gsub!(/5/, ' V ')

        value.gsub!(/lll|III/i, ' III ')
        value.gsub!(/okolie/i, ' okolie ')
        
        value.gsub!(/Kraj.\s*súd/, 'Krajský súd')
        
        value.gsub!(/B\.?\s*Bystrica/, 'Banská Bystrica')
        value.gsub!(/D\.\s*Kubín/, 'Dolný Kubín')

        value = " #{value} ".utf8

        value.gsub!(/\s+v\s+BA/, ' Bratislava')
        value.gsub!(/\s+v\s+ZA/, ' Žilina')

        value.gsub!(/\s+v\s+Bansk(á|ej)\s+Bystric(a|i)/i, ' Banská Bystrica')
        value.gsub!(/\s+v\s+Bratislav(a|e)/i, ' Bratislava')
        value.gsub!(/\s+v\s+Košic(a|iach)/i, ' Košice') 
        value.gsub!(/\s+v\s+Nitr(a|e)/i, ' Nitra')
        value.gsub!(/\s+v\s+Prešove?/i, ' Prešov')
        value.gsub!(/\s+v\s+Trenčíne?/i, ' Trenčín')
        value.gsub!(/\s+v\s+Trnav(a|e)/i, ' Trnava')
        value.gsub!(/\s+v\s+Žilin(a|e)/i, ' Žilina')

        value.squeeze!(' ')
        value.strip!

        value.gsub!(/n\/B/i, 'nad Bebravou')
        value.gsub!(/n\/V/i, 'nad Váhom')
        value.gsub!(/n\/T|n\.T\./i, 'nad Topľou')
        value.gsub!(/n\/H/i, 'nad Hronom')

        value.gsub!(/Najvyšší\s*súd(\s*SR)?/i, 'Najvyšší súd Slovenskej republiky')
        value.gsub!(/ŠTS(\s*v\s*Pezinku)?/i, 'Špecializovaný trestný súd')
        value.gsub!(/MS\s*SR/, 'Ministerstvo spravodlivosti Slovenskej republiky')
        value.gsub!(/NS\s*SR/, 'Najvyšší súd Slovenskej republiky')
        
        value.gsub!(/\./, '')

        value.utf8.split(/\s+/).map { |word|
          case word.utf8
          when 'KS' then 'Krajský súd'
          when 'OS' then 'Okresný súd'
          when 'BA' then 'Bratislava'
          when 'KE' then 'Košice'
          when 'ZA' then 'Žilina'
          when 'BB' then 'Banská Bystrica'

          when /\A(I|V)+\z/
            word
          when /\ASR\z/i
            'Slovenskej republiky'
          when /\A(a|v|nad|pre|súd|okolie|trestný|republiky)\z/i
            word.downcase
          else
            word.titlecase
          end
        }.join ' '
      end

      public

      def normalize_municipality_name(value)
        value.strip!

        value == 'Bratislava 33' ? 'Bratislava III' : value
      end

      def normalize_person_name(value, options = {})
        partition_person_name(value, options)[:value]
      end

      def partition_person_name(value, options = {})
        copy  = value.clone
        value = value.utf8

        prefixes  = []
        suffixes  = []
        additions = []
        uppercase = []
        mixedcase = []
        flags     = []

        _, representantive = *value.match(/((\,\s+)?hovorca)?\s+KS\s+(v\s+)?(?<municipality>.+)\z/i) 

        unless representantive.nil?
          flags << :representantive
          value.sub!(/((\,\s+)?hovorca\s+)?KS\s+(v\s+)?.+\z/i, '')
        end

        value.strip!
        value.gsub!(/[\,\;\(\)]/, '')
        value.gsub!(/(\.+\s*)+/, '. ')
        value.gsub!(/\s*\-\s*/, '-')
        
        value.split(/\s+/).each do |part|
          key = person_name_map_key(part)
          
          if prefix = person_name_prefix_map[key]
            prefixes << prefix
          elsif suffix = person_name_suffix_map[key]
            suffixes << suffix
          else
            part = part.utf8.strip
  
            if part =~ /\./
              if part =~ /rod\./i
                flags << :born
              elsif part =~ /(ml|st)\./
                flags << :relative
                additions << part
              end
            else
              if part.upcase == part
                uppercase << part.split(/\-/).map(&:titlecase).join(' - ')
              else
                mixedcase << part.split(/\-/).map(&:titlecase).join(' - ')
              end
            end
          end
        end
        
        prefixes.uniq!
        suffixes.uniq!

        names = mixedcase + uppercase

        if options[:reverse]
          if names.size >= 3
            names[0], names[1..-1] = names[-1], names[0..-2]
          else
            names.reverse!
          end
        end

        if flags.include? :born
          names << names.last
          names[-2] = 'rod.'
        end

        value = nil
        value = names.join(' ')                   unless names.empty?
        value = prefixes.join(' ') + ' ' + value  unless prefixes.empty?
        value = value + ' ' + additions.join(' ') unless additions.empty?
        value = value + ', ' + suffixes.join(' ') unless suffixes.empty?

        if flags.include? :representantive
          municipality ||= 'Trenčíne' unless representantive.match(/(TN|Trenčín(e)?)/).nil?
          municipality ||= 'Trnave'   unless representantive.match(/(TT|Trnav(a|e){1})/).nil?

          role  = "Hovorca krajského súdu v #{municipality}"
          value = value.blank? ? role : "#{value}, #{role.downcase_first}"
        end

        {
          unprocessed: copy.strip,
          value:       value,
          prefix:      prefixes.empty? ? nil : prefixes.join(' '),
          first:       names.count >= 2 ? names.first.to_s : nil,
          middle:      names.count >= 3 ? names[1..-2].join(' ') : nil,
          last:        names.last.to_s,
          suffix:      suffixes.empty? ? nil : suffixes.join(' '),
          addition:    additions.empty? ? nil : additions.join(' '),
          flags:       flags,
          role:        role
        }
      end

      private
      
      def person_name_prefix_map
        @person_name_prefix_map ||= person_name_map_using ['abs. v. š.',
         'akad.', 'akad. arch.', 'akad. mal.', 'akad. soch.', 'arch.', 'Bc.',
         'Bc. arch.', 'BcA.', 'B.Ed.', 'B.Sc.', 'Bw. (VWA)', 'doc.', 'Dr.',
         'Dr hab.', 'Dr inž.', 'Dr. jur.', 'Dr.h.c.', 'Dr.ir.', 'Dr.phil.',
         'Eng.', 'ICDr.', 'Ing.', 'Ing. arch.', 'JUC.', 'JUDr.', 'Kfm.',
         'Kfm. (FH)', 'Lic.', 'Mag', 'Mag.', 'Mag. (FH)', 'Mag. iur',
         'Magistra Artium', 'Mag.rer.nat.', 'MDDr.', 'MgA.', 'Mgr.',
         'Mgr. art.', 'mgr inž.', 'Mgr. phil.', 'MMag.', 'Mr.sc.', 'MSDr.',
         'MUc.', 'MUDr.', 'MVc.', 'MVDr.', 'PaedDr.', 'PharmDr.', 'PhDr.',
         'PhMr.', 'prof.', 'prof. mpx. h.c.', 'prof.h.c.', 'RCDr.', 'RNDr.',
         'RSDr.', 'ThDr.', 'ThLic.']
      end
      
      def person_name_suffix_map
        @person_name_suffix_map ||= person_name_map_using ['ArtD.', 'BA',
        'BA (Hons)', 'BBA', 'BBS', 'BBus', 'BBus (Hons)', 'BS', 'BSBA', 'BSc',
        'Cert Mgmt', 'CPA', 'CSc.', 'DDr.', 'Dipl. Ing.', 'Dipl. Kfm.',
        'Dipl.ECEIM', 'DiS.', 'DiS.art', 'Dr.', 'Dr.h.c.', 'DrSc.', 'DSc.',
        'EMBA', 'E.M.M.', 'Eqm.', 'Litt.D.', 'LL.A.', 'LL.B.', 'LL.M.',
        'M.A.', 'MAE', 'MAS', 'MBA', 'MBSc', 'M.C.L.', 'MEng.', 'MIM', 'MMBA',
        'MPH', 'M.Phil.', 'MS', 'MSc', 'M.S.Ed.', 'Ph.D.', 'PhD.',
        'prom. biol.', 'prom. ek.', 'prom. fil.', 'prom. filol.',
        'prom. fyz.', 'prom. geog.', 'prom. geol.', 'prom. hist.',
        'prom. chem.', 'prom. knih.', 'prom. logop.', 'prom. mat.',
        'prom. nov.', 'prom. ped.', 'prom. pharm.', 'prom. práv.',
        'prom. psych.', 'prom. vet.', 'prom. zub.', 'ThD.']
      end
      
      def person_name_map_using(values)
        values.inject({}) { |m, v| m[person_name_map_key(v)] = v; m }
      end
      
      def person_name_map_key(value)
        value.ascii.downcase.gsub(/[\s\.\,\;\-\(\)]/, '').to_sym
      end
      
      public
      
      def normalize_participant(value)
        value = normalize_punctuation(value)
        value = value.utf8
        
        value.split(/\s+/).map { |word|
          word = word.utf8
          
          word.gsub!(/ob[vž]\./i, '')
          
          key = person_name_map_key(word)
          
          if prefix = person_name_prefix_map[key]
            word = prefix
          elsif suffix = person_name_suffix_map[key]
            word = suffix
          else
            word = word.titlecase if word == word.upcase
          end
          
          word
        }.reject(&:blank?).join ' '
      end

      def normalize_zipcode(value)
        value = value.ascii.strip.gsub(/\s+/, '')

        "#{value[0..2]} #{value[3..-1]}"
      end

      def normalize_street(value)
        value = value.utf8

        value.gsub!(/\,/, ' ')
        value.gsub!(/\.\s*/, '. ')
        value.gsub!(/sv\./i, 'sv.')
        value.gsub!(/slov\./i, 'slovenskej')

        value.gsub!(/Námestie/i) { |s| "#{s[0]}ám." }
        value.gsub!(/Ulica/i)    { |s| "#{s[0]}l." }
        value.gsub!(/Číslo/i)    { |s| "#{s[0]}." }

        value.strip!
        value.squeeze!(' ')

        value
      end

      def normalize_email(value)
        value.split(/\,|\;/).map { |part| part.strip }.join ', '
      end

      def normalize_phone(value)
        value = value.gsub(/(\d+\s*)+/) { |part|
          part.gsub!(/\s/, '')
          
          case part.size
          when  7 then "#{part[0   ]} #{part[1..3]} #{part[4..6]} "
          when  8 then "#{part[0..1]} #{part[2..4]} #{part[5..7]} "
          when 10 then "#{part[0..3]} #{part[4..6]} #{part[7..9]} "
          else
            part + ' '
          end
        }

        value.gsub!(/\s*\/+\s*/, '/')
        value.gsub!(/\s*\-+\s*/, ' - ')
        value.gsub!(/\s*([\,\;])+\s*/, ', ')
        
        value.gsub!(/fax\s*\.\s*/i, ' fax ')
        value.gsub!(/kl(apka)?\s*\.\s*/i, ' klapka ')

        value.gsub!(/\s*@\s*/, '@')

        value.strip.squeeze(' ')
      end

      def normalize_hours(value)
        value = value.ascii.gsub(/[a-z]+/i, '')

        times = value.split(/\s*\-\s*|\,\s*|\;\s*|\s+/).map do |time|
          hour, minute = time.split(/\:/)
          "#{'%d' % hour.to_i}:#{'%02d' % minute.to_i}"
        end

        times.each_slice(2).map { |interval| "#{interval.first} - #{interval.last}" }.join ', '
      end

      def normalize_date(value)
        _, day, month, year = *value.strip.match(/(\d+)\.(\d+)\.(\d+)?/)

        "#{'%04d' % year.to_i}-#{'%02d' % month.to_i}-#{'%02d' % day.to_i}"
      end

      def normalize_datetime(value)
        _, day, month, year, hour, minute, second = *value.strip.match(/(\d+)\.(\d+)\.(\d+)\s+(\d+)\.(\d+)(\.(\d+))?/)

        hour   = 0 if hour.nil?
        minute = 0 if minute.nil?
        second = 0 if second.nil?

        date = "#{'%04d' % year.to_i}-#{'%02d' % month.to_i}-#{'%02d' % day.to_i}"
        time = "#{'%02d' % hour.to_i}:#{'%02d' % minute.to_i}:#{'%02d' % second.to_i}"

        "#{date} #{time}"
      end
      
      def normalize_legislation(value)
        partition_legislation(value)[:value]
      end
      
      def partition_legislation(value)
        map    = { unprocessed: value.clone.strip } 
        parts  = value.utf8.strip.split(/\,/).map { |part| part.strip }
        values = ['']
        
        if parts.first
          index = parts.first.index('/')
          
          if index
            type_and_number = parts.first[0..index - 1].strip
            year_and_name   = parts.first[index + 1..-1].strip
    
            type   = normalize_punctuation type_and_number.gsub(/\s*\d+\z/, '').strip.upcase_first
            number = type_and_number.match(/\d+\z/) { |m| m[0] }
            year   = year_and_name.match(/\A\d+/) { |m| m[0] }
            name   = year_and_name.gsub(/\A\d+\s*/, '')
            
            name.gsub!(/zbierky(\s+z[Áá]konov)?/i, 'Zbierky zákonov')
            name.gsub!(/\.\-/i, '.')
            name.gsub!(/\.\s+/i, '.')
            
            name = name.split(/\s+/).map { |word|
              word = word.utf8
              
              word.downcase_first! if word.match(/o|ktorým/i)
              
              word.gsub!(/obchodný/i, 'Obchodný')
              word.gsub!(/správny/i, 'Správny')
              word.gsub!(/zákonník/i, 'Zákonník')
              
              word.gsub!(/práce/i, 'práce')
              word.gsub!(/smerniva/i, 'smernica')
              
              word.gsub!(/\./, '. ')
              
              word.gsub!(/čl[\-\.]/i, 'článok')
              word.gsub!(/ods[\-\.]/i, 'odsek')
              word.gsub!(/písm[\-\.]/i, 'písmeno')
              
              word.gsub!(/obč\./i, 'Občiansky')
              word.gsub!(/tr\./i, 'Trestný')
              word.gsub!(/zák\./i, 'Zákon')

              word.gsub!(/por\./i, 'poriadok')
              word.gsub!(/rod\./i, 'rodine')

              word.gsub!(/o(\.\s*)*s(\.\s*)*p(\.\s*)*/i, 'Občiansky súdny poriadok')
              word.gsub!(/o(\.\s*)*z(\.\s*)*/i, 'Občiansky zákonník')
              word.gsub!(/o(\.\s*)*b(\.\s*)*(l(\.\s*)*)?z(\.\s*)*/i, 'Obchodný zákonník')
              word.gsub!(/z(\.\s*)*r(\.\s*)*/i, 'Zákon o rodine')

              word.gsub!(/z\.\s*č[\-\.]?/i, 'zákon č.')
              word.gsub!(/z\.\s*[bz]\.?/i, 'Zbierky zákonov')
              
              word
            }.join ' '
            
            name = normalize_punctuation name
          end

          values.first << "#{map[:type] = type} " unless type.blank?
          values.first << "#{number.blank? ? '?' : map[:number] = number}/#{year.blank? ? '?' : map[:year] = year}"
          values.first << " #{map[:name] = name}" unless name.blank?
        end
        
        if parts.second
          paragraph = parts.second.match(/\d+[a-z]*/i) { |m| m[0] }
          values << "§ #{map[:paragraph] = paragraph}" unless paragraph.blank?
        end
         
        if parts.third
          section = parts.third.match(/\d+/) { |m| m[0] }
          values << "Odsek #{map[:section] = section}" unless section.blank?
        end
        
        if parts.fourth
          letter = parts.fourth.match(/\s+(?<letter>[a-z]+)\s*\z/i) { |m| m[:letter].chars.to_a.join ' ' }
          values << "Písmeno #{map[:letter] = letter}" unless letter.blank?
        end
        
        map.merge value: values.join(', ')
      end
      
      def scan_paragraphs(value)
        value.scan(/§+\s*\d+[a-z]*/i).map { |p| p.sub(/§\s*/, '') }
      end

      def normalize_punctuation(value)
        value = value.utf8
        
        value.gsub!(/,\s*\z/, '')
        value.gsub!(/\,\-/, '')
        value.gsub!(/(\A|\s+)(\d*(\.|\,)\d+)+(\s+|\z)/) { |n| n.gsub(/\./, ' ') }

        value.gsub!(/\s*(\.\s*\.+\s*|(…\s*)+)+\s*/, '… ')
        value.gsub!(/\s*(?<c>[\.\;\:\?\!])+\s*/, '\k<c> ')
        value.gsub!(/(\A|[^\s^\d]+\d*)\s*\,/) { |s| s.gsub(/\s*\,+/, ', ') }
        value.gsub!(/\,+\s*(\d+(\s+|\z)|\d*[^\s^\d]+|\z)/) { |s| s.gsub(/\,+\s*/, ', ') }

        value.gsub!(/(\-\s*){3,}/, '--')
        value.gsub!(/\s*\-\-\s*/, ' – ')
        value.gsub!(/\s*\-\s*/, ' - ')

        value.gsub!(/\s*§+\s*/, ' § ')

        value.gsub!(/(\A|(?<n>\d+)|\s+)(€|eur)+(\s+|\z)/i, '\k<n> € ')
        value.gsub!(/(\A|(?<n>\d+)|\s+)(sk)+(\s+|\z)/i, '\k<n> Sk ')
        value.gsub!(/(\A|(?<n>\d+)|\s+)(kč)+(\s+|\z)/i, '\k<n> Kč ')

        value.gsub!(/\s*\/+\s*/, ' / ')
        value.gsub!(/(\s*\/+\s*\d)|(\d\s*\/+\s*)/) { |s| s.gsub(/\s*\/+\s*/, '/') }

        value.gsub!(/\s*(?<c>[\(\[\{])\s*/, ' \k<c>')
        value.gsub!(/\s*(?<c>[\)\]\}])\s*/, '\k<c> ')
        value.gsub!(/([\(\[\{]\s*)+/) { |s| s.gsub(/\s/, '') }
        value.gsub!(/(\s*[\)\]\}])+/) { |s| s.gsub(/\s/, '') }

        value.gsub!(/(s\s*\.\s*r\s*\.\s*o|k\s*\.\s*s|a\s*\.\s*s|o\s*\.\s*z|n\s*\.\s*o)\s*\.?/i) do |s|
          "#{s.gsub(/\s/, '').downcase}#{'.' unless s[-1] == '.'}"
        end

        value.strip.squeeze(' ')
      end
    end
  end
end
