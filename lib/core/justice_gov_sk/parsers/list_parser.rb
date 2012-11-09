# encoding: utf-8

module JusticeGovSk
  module Parsers
    class ListParser < HtmlParser
      def list(document)
        find_values 'list', document, 'table.GridTable td[align=right] a' do |anchors|
          anchors.map { |a| "#{JusticeGovSk::Requests::URL.base}#{a[:href]}" }
        end
      end
    
      def page(document)
        @page ||= find_value 'page', document, 'tr.CssPager select:first-child option[selected="selected"]' do |option|
          option.text
        end
      end
      
      def pages(document)
        @pages ||= find_value 'pages', document, 'tr.CssPager select:first-child option:last-child' do |option|
          option.text
        end
      end
      
      def per_page(document)
        find_value 'per page', document, 'tr.CssPager select:last-child option[selected="selected"]' do |option|
          option.text
        end
      end
    
      def next_page(document)
        k = page(document).to_i
        n = pages(document).to_i
        
        k + 1 if k < n
      end
      
      protected
      
      def clear_caches
        @page  = nil
        @pages = nil
      end
    end
  end
end
