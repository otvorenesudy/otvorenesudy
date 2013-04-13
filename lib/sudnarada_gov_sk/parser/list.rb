module SudnaradaGovSk
  class Parser
    class List < SudnaradaGovSk::Parser
      include Core::Parser::List
      
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
      
      protected
      
      def clear
        @page  = nil
        @pages = nil
      end
    end
  end
end
