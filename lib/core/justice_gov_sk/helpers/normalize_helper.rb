# encoding: utf-8

require 'classes/string'

module JusticeGovSk
  module Helpers
    module NormalizeHelper
      def self.person_name(value)
        prefixes = []
        sufixes  = []
        classes  = []
        names    = []
        
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
              names << part.titlecase
            else
              names = [part.titlecase] + names
            end
          end
        end
        
        value = names.join ' '
        value = prefixes.join(' ') + ' ' + value unless prefixes.empty?
        value = value + ' '  + classes.join(' ') unless classes.empty?
        value = value + ', ' + sufixes.join(' ') unless sufixes.empty?
        value
      end
    end
  end
end
