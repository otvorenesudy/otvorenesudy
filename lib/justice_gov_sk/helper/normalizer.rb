# encoding: utf-8

module JusticeGovSk
  module Helper
    module Normalizer
      def normalize_court_name(value)
        value.strip!
        value.gsub!(/\-/, '')
        value.squeeze!(' ')

        key = value.ascii.downcase

        court_name_map[key] || (value.utf8.split(/\s+/).map { |part|
          if !part.match(/\A(I|V)+\z/).nil?
            part
          elsif !part.match(/\A(v|nad|súd|okolie)\z/i).nil?
            part.downcase
          else
            part.titlecase
          end
        }.join ' ')
      end

      private

      def court_name_map
        return @court_name_map if @court_name_map

        map = {
          "Najvyšší súd SR"                => "Najvyšší súd Slovenskej republiky",
          "Najvyšší súd"                   => "Najvyšší súd Slovenskej republiky",
          "Ústavný súd SR"                 => "Ústavný súd Slovenskej republiky",
          "Špecializovaný trestný súd"     => "Špecializovaný trestný súd",

          "Krajský súd v Banskej Bystrici" => "Krajský súd Banská Bystrica",
          "Krajský súd v Bratislave"       => "Krajský súd Bratislava",
          "Krajský súd v Košiciach"        => "Krajský súd Košice", 
          "Krajský súd v Nitre"            => "Krajský súd Nitra",
          "Krajský súd v Prešove"          => "Krajský súd Prešov", 
          "Krajský súd v Trenčíne"         => "Krajský súd Trenčín",
          "Krajský súd v Trnave"           => "Krajský súd Trnava",
          "Krajský súd v Žiline"           => "Krajský súd Žilina",

          "Okresný súd Bánovce n/B"        => "Okresný súd Bánovce nad Bebravou",
          "Okresný súd Nové Mesto n/V"     => "Okresný súd Nové Mesto nad Váhom",
          "Okresný súd Vranov n/T"         => "Okresný súd Vranov nad Topľou",
          "Okresný súd Žiar n/H"           => "Okresný súd Žiar nad Hronom"
        }

        @court_name_map = {}

        map.each { |k, v| @court_name_map[k.ascii.downcase] = v }

        @court_name_map 
      end

      public

      def normalize_municipality_name(value)
        value.strip!

        value == "Bratislava 33" ? "Bratislava III" : value
      end

      def normalize_person_name(value)
        partition_person_name(value)[:altogether]
      end

      def partition_person_name(value)
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
  
            if part.match(/\./)
              if part.match(/rod\./i)
                flags << :born
              elsif part.match(/(ml|st)\./)
                flags << :relative
                additions << part
              end
            else
              if part == part.upcase
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

        if flags.include? :born
          names << names.last
          names[-2] = "rod."
        end

        value = nil
        value = names.join(' ')                   unless names.empty?
        value = prefixes.join(' ') + ' ' + value  unless prefixes.empty?
        value = value + ' ' + additions.join(' ') unless additions.empty?
        value = value + ', ' + suffixes.join(' ') unless suffixes.empty?

        if flags.include? :representantive
          municipality ||= "Trenčíne" unless representantive.match(/(TN|Trenčín(e)?)/).nil?
          municipality ||= "Trnave"   unless representantive.match(/(TT|Trnav(a|e){1})/).nil?

          role  = "Hovorca krajského súdu v #{municipality}"
          value = value.blank? ? role : "#{value}, #{role.downcase_first}"
        end

        {
          unprocessed: copy.strip,
          altogether:  value,
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

      def normalize_zipcode(value)
        value = value.ascii.strip.gsub(/\s+/, '')

        "#{value[0..2]} #{value[3..-1]}"
      end

      def normalize_street(value)
        value = value.utf8

        value.gsub!(/\,/, ' ')
        value.gsub!(/sv\./i, 'sv. ')
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

        # TODO impl   
      def normalize_phone(value)
        value.strip
  #        value.strip!
  #        
  #        value.split(/\,|\;/).map do |part|
  #          if part.match(/[a-zA-Z]/).nil?
  #            part.gsub!(/\s+/, '')
  #            
  #            unless part.match(/\//).nil?
  #              
  #            else
  #              
  #            end
  #          else
  #            part
  #          end
  #        end.join ', '
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

      def normalize_punctuation(value)
        value.gsub!(/\s*[\.\,\;]/) { |s| "#{s[-1]} " }
        value.gsub!(/[\.\,\;]\s+[\.\,\;]/) { |s| "#{s[0]}#{s[-1]}" }

        value.gsub!(/(s\s*\.\s*r\s*\.\s*o|k\s*\.\s*s|a\s*\.\s*s|o\s*\.\s*z|n\s*\.\s*o)\s*\.?/i) do |s|
          "#{s.gsub(/\s/, '').downcase}#{s[-1] == '.' ? '' : '.'}"
        end

        value.gsub!(/-/, ' - ')

        value.strip.squeeze(' ')
      end
    end
  end
end
