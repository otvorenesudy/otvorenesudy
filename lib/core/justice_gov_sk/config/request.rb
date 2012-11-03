# encoding: utf-8
module JusticeGovSk
  module Config
    module Request
      def headers
        {
          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
          "Accept-Charset" => "ISO-8859-1,utf-8;q=0.7,*;q=0.3", 
          "Accept-Encoding" => "gzip,deflate,sdch",
          "Accept-Language" => "en-US,en;q=0.8",
          "Cache-Control" => "max-age=0",
          "Connection" => "keep-alive",
          #"Content-Length" => 54791,
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "www.justice.gov.sk",
          "Origin" => "http://www.justice.gov.sk",
          "Referer" => "http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx",
          "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4"
        }
      end 
      
      def data
        @data || @data = File.read(File.join(File.dirname(__FILE__), "_dumps", request_dump_path))
      end

      def page(number)
        data.gsub!(/cmbAGVPager=\d+&/, "cmbAGVPager=#{number}&")
        self
      end

      def count(number)
        data.gsub!(/cmbAGVCountOnPage=\d+&/, "cmbAGVCountOnPage=#{number}&")
        self
      end
    end
  end
end
