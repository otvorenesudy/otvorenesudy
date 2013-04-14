module SudnaradaGovSk
  class Parser
    class JudgePropertyDeclarationList < SudnaradaGovSk::Parser::List
      def list(document)
        find_values 'list', document, 'table.table_list td.roky a', verbose: false do |anchors|
          anchors.map { |a| "#{SudnaradaGovSk::URL.base}#{a[:href].ascii}" }
        end
      end
      
      def page(document)
        @page ||= find_value 'page', document, 'div.pagelist b' do |bold|
          bold.text.to_i - 1
        end
      end
      
      def pages(document)
        @pages ||= find_value 'pages', document, 'div.pagelist a' do |anchors|
          pages = nil
          
          anchors.reverse.each do |anchor|
            if anchor.text =~ /\d+/
              pages = anchor.text.to_i
              break
            end 
          end
          
          pages
        end
      end
      
      def per_page(document)
        nil
      end
    end
  end
end
