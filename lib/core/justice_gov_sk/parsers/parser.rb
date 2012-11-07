# encoding: utf-8

module JusticeGovSk
  module Parsers
    class Parser < HtmlParser
      
      protected
      
      def find_value_by_group_and_index(name, element, group, k, &block)
        group = group.utf8.downcase
        
        rows   = table_rows(element)
        values = table_values(element)
        
        i = 0
        
        rows.each do |div|
          i += 1 if div[:class] == 'hodnota'
          break  if div[:class] == 'skupina' && div.text.utf8.downcase == group
        end
        
        find_value name, values[i + k], '', &block
      end
      
      def find_value_by_label(name, element, label, &block)
        label_to_index_map = table_label_to_index_map(element)
        
        find_value name, values[label_to_index_map[name.utf8.downcase]], '', &block
      end
      
      def clear_caches
        @table_rows               = nil
        @table_values             = nil
        @table_label_to_index_map = nil
      end
      
      private
      
      def table_rows(document)
        @table_rows ||= find_values 'information table, all rows', document, 'div.DetailTable div'
      end
      
      def table_values(document)
        @table_values ||= find_values 'information table, values only', document, 'div.DetailTable div.hodnota'
      end
      
      def table_label_to_index_map(document)
        return @table_label_to_index_map unless @table_label_to_index_map.nil?
        
        rows = table_rows(document)
        map  = {}
        
        i = 0
        
        rows.each do |div|
          if div[:class] == 'popiska'
            label = div.text.strip.gsub(/\:/, '').utf8.downcase
          elsif div[:class] == 'hodnota'
            index = i
            i += 1
          end
          
          unless label.nil? || index.nil? 
            map[label] = index
            label = index = nil
          end
        end
        
        @table_label_to_index_map ||= map
      end
    end
  end
end
