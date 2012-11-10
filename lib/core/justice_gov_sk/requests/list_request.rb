# encoding: utf-8

module JusticeGovSk
  module Requests
    class ListRequest
      attr_accessor :page

      attr_reader :per_page,
                  :data
      
      def headers
        {
          'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Charset'  => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3', 
          'Accept-Encoding' => 'gzip,deflate,sdch',
          'Accept-Language' => 'en-US,en;q=0.8',
          'Cache-Control'   => 'max-age=0',
          'Connection'      => 'keep-alive',
          'Content-Type'    => 'application/x-www-form-urlencoded',
          'Host'            => 'www.justice.gov.sk',
          'Origin'          => 'http://www.justice.gov.sk',
          'Cookie'          => '__utma=161066278.1275351275.1351816765.1352194655.1352230438.9; __utmz=161066278.1351816765.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmb=161066278.26.10.1352230438; __utmc=161066278; ASP.NET_SessionId=rqpypa55ahrhpge5valxzv45',
          'User-Agent'      => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4'
        }
      end
      
      def data
        @data ||= File.read data_path
      end

      def data_path
        name = self.class.name

        File.join Rails.root, 'lib', 'assets', "#{name.underscore}.data"
      end

      def page=(value)
        data.gsub!(/cmbAGVPager=\d+&/, "cmbAGVPager=#{value.to_i}&")
      end
      
      def page
        data.match(/cmbAGVPager=(?<value>\d+)&/)[:value].to_i
      end

#      def per_page=(value)
#        data.gsub!(/cmbAGVCountOnPage=\d+&/, "cmbAGVCountOnPage=#{value}&")
#      end

      def per_page
        data.match(/cmbAGVCountOnPage=(?<value>\d+)&/)[:value].to_i
      end
    end
  end
end
