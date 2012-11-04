# encoding: utf-8

module JusticeGovSk
  module Parsers
    class ListParser < HtmlParser
      def list(document)
        values document, 'table.GridTable td[align=right] a', 'page' do |anchors|
          anchors.map { |a| "#{JusticeGovSk::Config::URL.base}#{a[:href]}" }
        end
      end
    
      def page(document)
        return @page unless @page.nil?
        
        value document, 'tr.CssPager select:first-child option[selected="selected"]', 'page' do |option|
          @page ||= option.text
        end
      end
      
      def pages(document)
        return @pages unless @pages.nil?
        
        value document, 'tr.CssPager select:first-child option:last-child', 'pages' do |option|
          @pages ||= option.text
        end
      end
      
      def per_page(document)
        value document, 'tr.CssPager select:last-child option[selected="selected"]', 'per page' do |option|
          option.text
        end
      end
    
      def next_page(document)
        @page.to_i + 1 if @page < @pages
      end
    end
  end
end
