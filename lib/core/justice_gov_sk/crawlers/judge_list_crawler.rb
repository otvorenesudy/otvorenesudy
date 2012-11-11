module JusticeGovSk
  module Crawlers
    class JudgeListCrawler < JusticeGovSk::Crawlers::ListCrawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::JudgeListParser.new, persistor)
      end
      
      def crawl(request)
        super(request) do |list|
          list.each do |data|
            court = court(data)
            judge = judge(data)

            employment(court, judge, data)            
          end
        end
      end
      
      private
      
      def court(data)
        name = data[:court]

        court_by_name_factory.find(name) unless name.nil?
      end
      
      def judge(data)
        name = data[:name]

        unless name.nil?
          judge = judge_factory.find_or_create(name)
          
          judge.name             = name
          judge.name_unprocessed = name
          
          @persistor.persist(judge) if judge.id.nil?
        end
      end
      
      def judge_position(data)
        value = data[:position]

        unless value.nil?
          judge_position = judge_position_factory.find_or_create(value)
          
          judge_position.value = value
          
          @persistor.persist(judge_position) if judge_position.id.nil?
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
      end
    end
  end
end
