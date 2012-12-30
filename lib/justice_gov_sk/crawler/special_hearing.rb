module JusticeGovSk
  class Crawler
    class SpecialHearing < JusticeGovSk::Crawler::Hearing
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::SpecialHearing.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = preprocess(uri, content)

        @hearing.type = SpecialHearing.type
        
        @hearing.commencement_date = @parser.commencement_date(document)
        @hearing.selfjudge         = @parser.selfjudge(document)
        
        chair_judge(document)
        
        defendant(document)
        
        @persistor.persist(@hearing)
      end
      
      def chair_judge(document)
        name = @parser.chair_judge(document)
        
        unless name.nil?
          judge = judge_by_name_factory.find(name[:altogether])
          exact = nil
          
          unless judge.nil?
            exact = true
          # TODO refactor, see todos in decree crawler
          #else
          #  judge = judge_factory_by_last_and_middle_and_first.find(name[:last], name[:middle], name[:first])
          #  exact = false unless judge.nil?
          end
          
          @hearing.chair_judge                  = judge
          @hearing.chair_judge_matched_exactly  = exact
          @hearing.chair_judge_name_unprocessed = name[:unprocessed]
        end
      end
      
      def defendant(document)
        name = @parser.defendant(document)
        
        unless name.nil?
          defendant = defendant_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name)
          
          defendant.hearing = @hearing
          defendant.name    = name
          
          @persistor.persist(defendant) if defendant.id.nil?
        end
      end
    end
  end
end
