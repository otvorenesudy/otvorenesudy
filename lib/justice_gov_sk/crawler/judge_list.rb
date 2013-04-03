module JusticeGovSk
  class Crawler
    class JudgeList < JusticeGovSk::Crawler::List
      protected
      
      include JusticeGovSk::Helper::UpdateController::Instance
      
      def process(request)
        super(request) do |item|
          data = @parser.data(item)
          name = data[:name]
          
          judge = judge_by_name_unprocessed_factory.find_or_create(name[:unprocessed])
          
          next judge unless crawlable?(judge)
          
          judge.name             = name[:altogether]
          judge.name_unprocessed = name[:unprocessed]
          
          judge.prefix   = name[:prefix]
          judge.first    = name[:first]
          judge.middle   = name[:middle]
          judge.last     = name[:last]
          judge.suffix   = name[:suffix]
          judge.addition = name[:addition]
          
          @persistor.persist(judge)
          
          court = court_by_name_factory.find(data[:court]) unless data[:court].nil?

          employment(court, judge, data)
          
          judge
        end
      end
      
      private
      
      def employment(court, judge, data)
        employment = employment_by_court_id_and_judge_id_factory.find_or_create(court.id, judge.id)
        
        employment.court          = court
        employment.judge          = judge
        employment.judge_position = judge_position(data)
        employment.active         = data[:active]
        employment.note           = data[:note]

        @persistor.persist(employment)
        
        employment
      end
      
      def judge_position(data)
        value = data[:position]

        unless value.nil?
          judge_position = judge_position_by_value_factory.find_or_create(value)
          
          judge_position.value = value
          
          @persistor.persist(judge_position)
          
          judge_position
        end
      end
    end
  end
end
