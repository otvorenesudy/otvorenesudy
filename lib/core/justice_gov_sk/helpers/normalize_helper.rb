# encoding: utf-8

require 'classes/string'

module JusticeGovSk
  module Helpers
    module NormalizeHelper
      def self.person_name(value)
        prefixes  = [] 
        sufixes   = [] 
        classes   = []
        uppercase = []
        mixedcase = []
        
        value.gsub(/[\,\;]/, '').split(/\s+/).each do |part|
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

      def self.court(name)
        values = {
          "Krajský súd Banská Bystrica" => "Krajský súd v Banskej Bystrici",
          "Krajský súd Bratislava"      => "Krajský súd v Bratislave",
          "Krajský súd Košice"          => "Krajský súd v Košiciach", 
          "Krajský súd Nitra"           => "Krajský súd v Nitre",
          "Krajský súd Prešov"         => "Krajský súd v Prešove", 
          "Krajský súd Trenčín"         => "Krajský súd v Trenčíne",
          "Krajský súd Trnava"         => "Krajský súd v Trnave",
          "Krajský súd Žilina"         => "Krajský súd v Žiline"
        }

        values[name].nil ? name : values[name]
      end
    end
  end
  end
