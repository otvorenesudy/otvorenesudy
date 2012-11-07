# encoding: utf-8

module JusticeGovSk
  module Parsers
    class Parser < HtmlParser
      
      protected
      
      def value_from_group(document, group, k, name, &block)
        group = group.utf8.downcase
        
        rows   = table_rows(document)
        values = table_values(document)
        
        i = 0
        
        rows.each do |div|
          i += 1 if div[:class] == 'hodnota'
          break if div[:class] == 'skupina' && div.text.utf8.downcase == group
        end
        
        value values[i + k], '', name, &block
      end
      
      def value_by_label(document, label, name, &block)
        label_to_index_map = table_label_to_index_map(document)
        
        value values[label_to_index_map[name.utf8.downcase]], '', name, &block
      end
      
      private
      
      # TODO consider caching; problem: clear caches after document changed?
      
      def table_rows(document)
        @table_rows ||= values document, 'div.DetailTable div', 'information table, all rows'
      end
      
      def table_values(document)
        @table_values ||= values document, 'div.DetailTable div.hodnota', 'information table, values only'
      end
      
      def table_label_to_index_map(document)
        return label_to_index_map unless @label_to_index_map.nil?
        
        rows = table_rows(document)
        map  = {}
        
        i = 0
        
        rows.each do |div|
          if div[:class] == 'popiska' then label = div.text.utf8.downcase end
          if div[:class] == 'hodnota' then index = i; i += 1 end
          
          unless label.nil? || index.nil? 
            map[label] = index
            label = index = nil
          end
        end
        
        @label_to_index_map ||= map
      end
    end
  end
end
