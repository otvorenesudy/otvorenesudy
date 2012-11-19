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

        court_name_map[key].nil? ? value : court_name_map[key]
      end
      
      private
      
      def self.court_name_map
        return @map unless @map.nil?
        
        map = {
          "Najvyšší súd SR"             => "Najvyšší súd Slovenskej republiky",
          "Ústavný súd SR"              => "Ústavný súd Slovenskej republiky",
          
          "Krajský súd v Banskej Bystrici" => "Krajský súd Banská Bystrica",
          "Krajský súd v Bratislave"       => "Krajský súd Bratislava",
          "Krajský súd v Košiciach"        => "Krajský súd Košice", 
          "Krajský súd v Nitre"            => "Krajský súd Nitra",
          "Krajský súd v Prešove"          => "Krajský súd Prešov", 
          "Krajský súd v Trenčíne"         => "Krajský súd Trenčín",
          "Krajský súd v Trnave"           => "Krajský súd Trnava",
          "Krajský súd v Žiline"           => "Krajský súd Žilina"
        }
        
        @map = {}
        
        map.each { |k, v| @map[k.ascii.downcase] = v }
        
        @map 
      end

      public

      # TODO see all media_person names and fix this      
      def self.person_name(value)
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
        value
      end
      
      def self.zipcode(value)
        value = value.strip.gsub(/\s+/, '')
        
        "#{value[0..2]} #{value[3..-1]}"
      end
      
      def self.street(value)
        # TODO implement
        value.strip
      end
      
      def self.email(value)
        value.split(/\,|\;/).map { |part| part.strip }.join ', '
      end
      
      def self.phone(value)
        value.strip
        
        # TODO implement
        #numbers = []
        #
        #value.split(/\,|\;/).map do |part|
        #  part.gsub!(/\s+/, '')
        #  
        #  
        #end
        #
        #numbers.join ', '
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
    end
  end
end
