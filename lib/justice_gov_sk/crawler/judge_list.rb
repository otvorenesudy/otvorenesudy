module JusticeGovSk
  class Crawler
    class JudgeList < JusticeGovSk::Crawler::List
      protected
      
      include JusticeGovSk::Helper::JudgeMaker
      include JusticeGovSk::Helper::UpdateController::Resource
      
      def process(request)
        super(request) do |item|
          uri     = JusticeGovSk::Request.uri(request)
          data    = @parser.data(item)
          options = { require_court: true, require_position: true }

          next unless crawlable?(Judge, uri) 
          
          make_judge uri, JusticeGovSk.source, data[:name], data, options
        end
      end
    end
  end
end
