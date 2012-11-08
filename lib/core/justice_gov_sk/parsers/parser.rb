# encoding: utf-8

module JusticeGovSk
  module Parsers
    class Parser < HtmlParser
      
      protected
      
      def find_value_by_group_and_index(name, element, group, k, &block)
        group  = table_key(group)
        rows   = table_rows(element)
        values = table_values(element)
        
        i = 0
        
        rows.each do |div|
          i += 1 if div[:class] == 'hodnota'
          break  if div[:class] == 'skupina' && table_key(div.text) == group
        end
        
        find_value name, values[i + k], '', &block
      end
      
      def find_value_by_label(name, element, label, &block)
        label = table_key(label)
        rows  = table_rows(element)
        
        index = nil
        
        rows.each_with_index do |div, i|
          if div[:class] == 'popiska' && table_key(div.text) == label
            i.upto(rows.count - 1) do |k|
              if rows[k][:class] == 'hodnota'
                index = k
                break
              end
            end
            
            break
          end
        end
        
        find_value name, rows[index], '', &block
      end
      
      def clear_caches
        @table_rows   = nil
        @table_values = nil
      end
      
      private
      
      # TODO refactor & fix bug: table_rows(document) ->  table_rows   
      
      def table_rows(document)
        @table_rows ||= find_values('information table, all rows', document, 'div.DetailTable div').select do |div|
          !div[:class].match(/skupina|popiska|hodnota/).nil?
        end
      end
      
      def table_values(document)
        @table_values ||= find_values 'information table, values only', document, 'div.DetailTable div.hodnota'
      end
      
      def table_key(s)
        s.utf8.strip.downcase.gsub(/:/,'')
      end
    end
  end
end
