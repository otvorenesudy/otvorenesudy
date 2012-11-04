# encoding: utf-8

module JusticeGovSk
  module Config
    module ListRequest
      def headers
        {
          'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3', 
          'Accept-Encoding' => 'gzip,deflate,sdch',
          'Accept-Language' => 'en-US,en;q=0.8',
          'Cache-Control' => 'max-age=0',
          'Connection' => 'keep-alive',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Host' => 'www.justice.gov.sk',
          'Origin' => 'http://www.justice.gov.sk',
          'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4'
        }
      end 
      
      def data
        @data ||= File.read data_path
      end

      def data_path
        name = self.class.name.split('::').last

        File.join Rails.root, 'lib', 'assets', 'request_data', "#{name.underscore}.data"
      end

      def page(number)
        data.gsub!(/cmbAGVPager=\d+&/, "cmbAGVPager=#{number}&")
        self
      end

      def per_page(number)
        data.gsub!(/cmbAGVCountOnPage=\d+&/, "cmbAGVCountOnPage=#{number}&")
        self
      end
    end
  end
end
