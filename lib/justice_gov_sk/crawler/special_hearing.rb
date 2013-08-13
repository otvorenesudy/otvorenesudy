module JusticeGovSk
  class Crawler
    class SpecialHearing < JusticeGovSk::Crawler::Hearing
      protected
      
      def process(request)
        super do
          @hearing.type = HearingType.special
          
          @hearing.commencement_date = @parser.commencement_date(@document)
          @hearing.selfjudge         = @parser.selfjudge(@document)
          
          chair_judge
          
          defendant
          
          @hearing
        end
      end
      
      def chair_judge
# TODO try to supply
#        supply @hearing, :chair_judge, parse: :name, instance: Proc.new {}, factory: lambda { |name|
#          match_judges_by(name) do |similarity, judge|
#            judging(judge, similarity, name, true)#.judge
#          end
#        }
        
        name = @parser.chair_judge(@document)
        
        unless name[:value].nil?
          match_judges_by(name) do |similarity, judge|
            judge = make_judge(@hearing.uri, @hearing.source, name, court: @hearing.court) unless judge
            
            judging(judge, similarity, name, true)
          end
        end
      end
      
      def defendant
        name = @parser.defendant(@document)
        
        unless name.nil?
          defendant = defendant_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name[:normalized])
          
          defendant.hearing          = @hearing
          defendant.name             = name[:normalized]
          defendant.name_unprocessed = name[:unprocessed]
          
          @persistor.persist(defendant)
        end
      end
    end
  end
end
