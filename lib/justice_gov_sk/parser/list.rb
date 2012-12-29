# encoding: utf-8

module JusticeGovSk
  module Parser
    class List < JusticeGovSk::Parser
      def list(document)
        find_values 'list', document, 'table.GridTable td[align=right] a', verbose: false do |anchors|
          anchors.map { |a| "#{JusticeGovSk::URL.base}#{a[:href]}" }
        end
      end
      
      def page(document)
        @page ||= find_value 'page', document, 'tr.CssPager select:first-child option[selected="selected"]' do |option|
          option.text.to_i
        end
      end
      
      def pages(document)
        @pages ||= find_value 'pages', document, 'tr.CssPager select:first-child option:last-child' do |option|
          option.text.to_i
        end
      end
      
      def per_page(document)
        find_value 'per page', document, 'tr.CssPager select:last-child option[selected="selected"]' do |option|
          option.text.to_i
        end
      end
    
      def next_page(document)
        k = page(document)
        n = pages(document)
        
        k + 1 if k && n && k < n
      end
      
      protected
      
      def clear_caches
        @page  = nil
        @pages = nil
      end
    end
  end
end
