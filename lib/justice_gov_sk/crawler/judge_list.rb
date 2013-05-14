module JusticeGovSk
  class Crawler
    class JudgeList < JusticeGovSk::Crawler::List
      protected
      
      include JusticeGovSk::Helper::JudgeMaker
      include JusticeGovSk::Helper::UpdateController::Resource
      
      def process(request)
        super(request) do |item|
          uri  = JusticeGovSk::Request.uri(request)
          data = @parser.data(item)
          name = data[:name]

          next unless crawlable?(Judge, uri) 
          
          judge = make_judge uri, JusticeGovSk.source, name
          
          @persistor.persist(judge)
          
          court    = court_by_name_factory.find(data[:court]) unless data[:court].nil?
          position = make_judge_position(data[:position])
  
          @persistor.persist(position)
  
          employment = make_employment(court, judge, position, data[:active], data[:note])
          
          @persistor.persist(employment)
          
          judge
        end
      end
    end
  end
end
