# encoding: utf-8

# http://sk.wikipedia.org/wiki/Akademický_titul

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
        return @court_name_map unless @court_name_map.nil?
        
        map = {
          "Najvyšší súd SR"                => "Najvyšší súd Slovenskej republiky",
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
          
          "Okresný súd Bánovce n/B"        => "Okresný súd Bánovce nad Bebravou"
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
        
        _, special = *value.match(/((\,\s+)?hovorca)?\s+KS\s+(v\s+)?(?<municipality>.+)\z/i) 
        
        value.sub!(/((\,\s+)?hovorca\s+)?KS\s+(v\s+)?.+\z/i, '') unless special.nil?
        
        prefixes  = []
        suffixes  = []
        additions = []
        uppercase = []
        mixedcase = []
        
        value.strip.gsub(/[\,\;]/, '').split(/\s+/).each do |part|
          part = part.utf8.squeeze('.').strip
          
          if part.match(/\./)
            if part.match(/(PhD|CSc|DrSc)\./i)
              suffixes << part
            elsif part.match(/\((ml|st)\.\)/)
              additions << part.gsub(/[\(\)]/, '')
            else
              part.downcase! if part.match(/(akad|arch|art|doc|prof)\./i)
              
              prefixes << part
            end
          else
            if part == part.upcase
              uppercase << part.titlecase
            else
              mixedcase << part.titlecase
            end
          end
        end
        
        names = mixedcase + uppercase
        
        value = nil
        value = names.join(' ') unless names.empty?
        value = prefixes.join(' ') + ' ' + value unless prefixes.empty?
        value = value + ' ' + additions.join(' ') unless additions.empty?
        value = value + ', ' + suffixes.join(' ') unless suffixes.empty?
        
        unless special.nil?
          municipality ||= "Trenčíne" unless special.match(/(TN|Trenčín(e)?)/).nil?
          municipality ||= "Trnave"   unless special.match(/(TT|Trnav(a|e){1})/).nil?
          
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
          role:        role
        }
      end
      
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
