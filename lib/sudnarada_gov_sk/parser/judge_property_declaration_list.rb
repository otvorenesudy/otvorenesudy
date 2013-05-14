module SudnaradaGovSk
  class Parser
    class JudgePropertyDeclarationList < SudnaradaGovSk::Parser::List
      def list(document)
        find_values 'list', document, 'table.table_list tr[class^=tab]', verbose: false do |rows|
          rows.map do |row|
            data   = row.search('td')
            anchor = data.search('a').first
            url    = "#{SudnaradaGovSk::URL.base}#{anchor[:href].ascii}"
            court  = normalize_court_name(data[1].text)
            
            SudnaradaGovSk::Request::JudgePropertyDeclaration.new url: url, court: court 
          end
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
