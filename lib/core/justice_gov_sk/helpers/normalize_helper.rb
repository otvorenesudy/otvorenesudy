# encoding: utf-8

require 'classes/string'

module JusticeGovSk
  module Helpers
    module NormalizeHelper
      def self.court_name(value)
        value.strip!
        value.gsub!(/\-/, '')
        value.squeeze!(' ')
        
        key = value.ascii.downcase

        court_name_map[key] || (value.utf8.split(/\s+/).map do |part|
          if ['v', 'nad', 'súd', 'okolie'].include? part
            part.downcase
          elsif !part.match(/\A(I|V)+\z/).nil?
            part
          else
            part.titlecase
          end
        end.join ' ')
      end
      
      private
      
      def self.court_name_map
        return @court_name_map unless @court_name_map.nil?
        
        map = {
          "Najvyšší súd SR"                => "Najvyšší súd Slovenskej republiky",
          "Ústavný súd SR"                 => "Ústavný súd Slovenskej republiky",
          
          "Krajský súd v Banskej Bystrici" => "Krajský súd Banská Bystrica",
          "Krajský súd v Bratislave"       => "Krajský súd Bratislava",
          "Krajský súd v Košiciach"        => "Krajský súd Košice", 
          "Krajský súd v Nitre"            => "Krajský súd Nitra",
          "Krajský súd v Prešove"          => "Krajský súd Prešov", 
          "Krajský súd v Trenčíne"         => "Krajský súd Trenčín",
          "Krajský súd v Trnave"           => "Krajský súd Trnava",
          "Krajský súd v Žiline"           => "Krajský súd Žilina"
        }
        
        @court_name_map = {}
        
        map.each { |k, v| @court_name_map[k.ascii.downcase] = v }
        
        @court_name_map 
      end

      public
      
      def self.municipality_name(value)
        value.strip!
        
        value == 'Bratislava 33' ? 'Bratislava III' : value
      end

      def self.person_name(value)
        value = value.utf8
        
        _, special = *value.match(/((\,\s+)?hovorca\s+)?KS\s+(v\s+)?(?<municipality>.+)\z/i) 
        
        value.sub!(/((\,\s+)?hovorca\s+)?KS\s+(v\s+)?.+\z/i, '') unless special.nil?
        
        prefixes  = []
        sufixes   = []
        classes   = []
        uppercase = []
        mixedcase = []
        
        value.strip.gsub(/[\,\;]/, '').split(/\s+/).each do |part|
          part = part.utf8.strip
          
          unless part.match(/\./).nil?
            if not part.match(/(PhD|CSc)\./i).nil?
              sufixes << part
            elsif not part.match(/\((ml|st)\.\)/).nil?
              classes << part
            else
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
        
        value = nil
        
        value = mixedcase.join(' ') unless mixedcase.empty?
        value = (value.nil? ? '' : "#{value} ") + uppercase.join(' ') unless uppercase.empty?
        value = prefixes.join(' ') + ' ' + value unless prefixes.empty?
        value = value + ' '  + classes.join(' ') unless classes.empty?
        value = value + ', ' + sufixes.join(' ') unless sufixes.empty?
        
        unless special.nil?
          municipality ||= "Trenčíne" unless special.match(/(TN|Trenčín(e)?)/).nil?
          municipality ||= "Trnave"   unless special.match(/(TT|Trnav(a|e){1})/).nil?
          
          role  = "Hovorca krajského súdu v #{municipality}"
          value = value.blank? ? role : "#{value}, #{role.downcase_first}"
        end
        
        value
      end
      
      def self.zipcode(value)
        value = value.strip.gsub(/\s+/, '')
        
        "#{value[0..2]} #{value[3..-1]}"
      end
      
      def self.street(value)
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
      
      def self.email(value)
        value.split(/\,|\;/).map { |part| part.strip }.join ', '
      end
 
      # TODO impl   
      def self.phone(value)
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
      
      def self.hours(value)
        value.split(/\,|\;/).map do |interval|
          interval.split(/\-/).map do |time|
            hour, minute = time.split(/\:/)
            "#{'%d' % hour.to_i}:#{'%02d' % minute.to_i}"
          end.join ' - '
        end.join ', '
      end

      def self.date(value)
        _, day, month, year = *value.strip.match(/(\d+)\.(\d+)\.(\d+)?/)

        "#{'%04d' % year.to_i}-#{'%02d' % month.to_i}-#{'%02d' % day.to_i}"
      end
      
      def self.datetime(value)
        _, day, month, year, hour, minute, second = *value.strip.match(/(\d+)\.(\d+)\.(\d+)\s+(\d+)\.(\d+)(\.(\d+))?/)

        hour   = 0 if hour.nil?
        minute = 0 if minute.nil?
        second = 0 if second.nil?
        
        date = "#{'%04d' % year.to_i}-#{'%02d' % month.to_i}-#{'%02d' % day.to_i}"
        time = "#{'%02d' % hour.to_i}:#{'%02d' % minute.to_i}:#{'%02d' % second.to_i}"
        
        "#{date} #{time}"
      end
      
      def self.punctuation(value)
        value.gsub!(/\s*[\.\,\;]/) { |s| "#{s[-1]} " }
        value.gsub!(/-/, ' - ')
        
        value.strip.squeeze(' ')
      end
    end
  end
end
