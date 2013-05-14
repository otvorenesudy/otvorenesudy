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
          
          supply @hearing, :defendant, { parse: :name,
            defaults: { hearing_id: @hearing.id },
            factory: { args: [:hearing_id, :name] },
            association: :has_many
          }
          
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
        
        unless name.nil?
          match_judges_by(name) do |similarity, judge|
            judge = make_judge(@hearing.uri, @hearing.source, name, court: @hearing.court) unless judge
            
            judging(judge, similarity, name, true)
          end
        end
      end
    end
  end
end
