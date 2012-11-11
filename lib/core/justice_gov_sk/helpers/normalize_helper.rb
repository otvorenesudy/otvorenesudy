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
      
      def self.datetime(value)
        m = value.strip.match(/(?<day>\d+)\.(?<month>\d+)\.(?<year>\d+)\s+(?<hour>\d+)\.(?<minute>\d+)(\.(?<second>\d+))?/)
        
        m[:hour]   = 0 if m.names.include? :hour
        m[:minute] = 0 if m.names.include? :minute
        m[:second] = 0 if m.names.include? :second
        
        date = "#{'%04d' % m[:year].to_i}-#{'%02d' % m[:month].to_i}-#{'%02d' % m[:day].to_i}"
        time = "#{'%02d' % m[:hour].to_i}:#{'%02d' % m[:minute].to_i}:#{'%02d' % m[:second].to_i}"
        
        "#{date} #{time}"
      end
    end
  end
end
