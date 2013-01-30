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
          
          supply @hearing, :defendant, { parse: [:name],
            defaults: { hearing_id: @hearing.id },
            factory: { args: [:hearing_id, :name] }
          }
          
          @hearing
        end
      end
      
      def chair_judge
        name = @parser.chair_judge(@document)
        
        unless name.nil?
          match_judges_by(name) do |similarity, judge|
            judging(judge, similarity, name, true)
          end
        end
      end
    end
  end
end
