module JusticeGovSk
  module Crawler
    class JudgeList < JusticeGovSk::Crawler::ListCrawler
      include Core::Factories
      include Core::Identify
      include Core::Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::JudgeList.new, persistor)
      end
      
      def crawl(request)
        super(request) do |elements|
          elements.each do |element|
            data  = @parser.data(element)
            court = court(data)
            judge = judge(data)

            employment(court, judge, data)            
          end
        end
      end
      
      private
      
      def court(data)
        name = data[:court]
        
        unless name.nil?
          court_by_name_factory.find(name)
        end
      end
      
      def judge(data)
        name = data[:name]

        unless name.nil?
          judge = judge_factory.find_or_create(name[:altogether])
          
          judge.name             = name[:altogether]
          judge.name_unprocessed = name[:unprocessed]
          
          judge.prefix   = name[:prefix]
          judge.first    = name[:first]
          judge.middle   = name[:middle]
          judge.last     = name[:last]
          judge.suffix   = name[:suffix]
          judge.addition = name[:addition]
          
          @persistor.persist(judge) if judge.id.nil?
          
          judge
        end
      end
      
      def judge_position(data)
        value = data[:position]

        unless value.nil?
          judge_position = judge_position_factory.find_or_create(value)
          
          judge_position.value = value
          
          @persistor.persist(judge_position) if judge_position.id.nil?
          
          judge_position
        end
      end
      
      def employment(court, judge, data)
        employment = employment_factory.find_or_create(court.id, judge.id)
        
        employment.court          = court
        employment.judge          = judge
        employment.judge_position = judge_position(data)
        employment.active         = data[:active]
        employment.note           = data[:note]

        @persistor.persist(employment) if employment.id.nil?
        
        employment
      end
    end
  end
end
