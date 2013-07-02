# encoding: utf-8

module JusticeGovSk
  class Parser
    class Decree < JusticeGovSk::Parser
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
          normalize_date(div.text)
        end
      end

      def ecli(document)
        find_value_by_label 'ECLI', document, 'ECLI' do |div|
          div.text.strip
        end
      end
      
      def court(document)
        find_value_by_label 'court', document, 'Súd' do |div|
          normalize_court_name(div.search('a').first.text)
        end
      end  
        
      def judge(document)
        find_value_by_label 'judge', document, 'Meno a priezvisko sudcu, VSÚ', verbose: false do |div|
          partition_person_name(div.search('a').first.text)
        end
      end
        
      def natures(document)
        find_value_by_label 'nature', document, 'Povaha rozhodnutia', verbose: false do |div|
          div.search('span').map { |span| span.text.strip.split(/\n/).map { |s| s.strip }}.flatten
        end
      end

      def legislation_area(document)
        legislation_area_and_subarea(document).split('-').first.strip unless legislation_area_and_subarea(document).blank?
      end
      
      def legislation_subarea(document)
        legislation_area_and_subarea(document).split('-').last.strip unless legislation_area_and_subarea(document).blank?
      end
        
      def legislations(document)
        find_value_by_label 'legislations', document, 'Predpisy odkazované v rozhodnutí', verbose: false do |div|
          div.search('span').map { |span| span.text }
        end
      end

      def legislation(value)
        partition_legislation(value)
      end
      
      def summary(document)
        find_value_by_label 'summary', document, 'Sumár' do |div|
          normalize_punctuation(div.text.gsub(/\A\s*\-+/, ''))
        end
      end
      
      protected
      
      def clear
        super
        
        @legislation_area_and_subarea = nil
      end
      
      private
      
      def legislation_area_and_subarea(document)
        @legislation_area_and_subarea ||= find_value_by_label 'legislation area and subarea', document, 'Oblasti právnej úpravy' do |div|
          div.text.strip.squeeze(' ')
        end
      end
    end
  end
end
