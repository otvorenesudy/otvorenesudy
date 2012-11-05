# encoding: utf-8

module JusticeGovSk
  module Parsers
    class DecreeParser < HtmlParser
      def case_number(document)
        value document, 'div.DetailTable div.hodnota', 'case number' do |divs|
          divs[1].text.strip
        end
      end
      
      def file_number(document)
        value document, 'div.DetailTable div.hodnota', 'file number' do |divs|
          divs[2].text.strip
        end
      end

      def date(document)
        value document, 'div.DetailTable div.hodnota', 'date' do |divs|
          divs[3].text.strip
        end
      end

      def ecli(document)
        value document, 'div.DetailTable div.hodnota', 'ECLI' do |divs|
          divs[5].text.strip
        end
      end

      def court(document)
        value document, 'div.DetailTable div.hodnota a', 'court' do |anchors|
          anchors[0][:href].strip
        end
      end  
        
      def judge(document)
        value document, 'div.DetailTable div.hodnota a', 'judge' do |anchors|
          anchors[4][:href].strip
        end
      end
        
      def nature(document)
        value document, 'div.DetailTable div.hodnota', 'nature' do |divs|
          divs[7].text.strip
        end
      end
      
      def legislation_area(document)
        value document, 'div.DetailTable div.hodnota', 'legislation area' do |divs|
          divs[6].text.split('-').first.strip
        end
      end
      
      def legislation_subarea(document)
        value document, 'div.DetailTable div.hodnota', 'legislation subarea' do |divs|
          divs[6].text.split('-').last.strip
        end
      end
        
      def legislations(document)
        values document, 'div.DetailTable div.hodnota span', 'legislations' do |spans|
          spans.map do |span|
            
          end
        end
      end
    end
  end
end
