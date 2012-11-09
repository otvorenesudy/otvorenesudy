# encoding: utf-8

module JusticeGovSk
  module Parsers
    class DecreeParser < JusticeGovSk::Parsers::Parser
      def case_number(document)
        find_value_by_label 'case number', document, 'Spisová značka' do |div|
          div.search('a').first.text.strip
        end
      end
      
      def file_number(document)
        find_value_by_label 'file number', document, 'Identifikačné číslo súdneho spisu' do |div|
          div.search('a').first.text.strip
        end
      end

      def date(document)
        find_value_by_label 'date', document, 'Dátum vydania rozhodnutia' do |div|
          div.text.strip
        end
      end

      def ecli(document)
        find_value_by_label 'ECLI', document, 'ECLI' do |div|
          div.text.strip
        end
      end

      def court(document)
        find_value_by_label 'court', document, 'Súd' do |div|
          div.search('a').first.text.strip
        end
      end  
        
      def judge(document)
        find_value_by_label 'judge', document, 'Meno a priezvisko sudcu, VSÚ' do |div|
          div.search('a').first.text.strip
        end
      end
        
      def nature(document)
        find_value_by_label 'nature', document, 'Povaha rozhodnutia' do |div|
          div.text.strip
        end
      end

      def legislation_area(document)
        legislation_area_and_subarea.split('-').first.strip
      end
      
      def legislation_subarea(document)
        legislation_area_and_subarea.split('-').last.strip
      end
        
      def legislations(document)
      end

      def legislation(document)
      end
      
      protected
      
      def clear_caches
        super
        
        @legislation_area_and_subarea = nil
      end
      
      private
      
      def legislation_area_and_subarea(document)
        @legislation_area_and_subarea ||= find_value_by_label 'legislation area and subarea', document, 'Oblasti právnej úpravy' do |div|
          div.text.strip
        end
      end
    end
  end
end
