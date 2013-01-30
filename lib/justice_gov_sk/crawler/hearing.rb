module JusticeGovSk
  class Crawler
    class Hearing < JusticeGovSk::Crawler
      protected
    
      include JusticeGovSk::Helper::JudgeMatcher
      include JusticeGovSk::Helper::ProceedingSupplier
      
      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)
          
          @hearing = hearing_by_uri_factory.find_or_create(uri)
          
          @hearing.uri = uri
  
          @hearing.case_number = @parser.case_number(@document)
          @hearing.file_number = @parser.file_number(@document)
          @hearing.date        = @parser.date(@document)
          @hearing.room        = @parser.room(@document)
          @hearing.note        = @parser.note(@document)
        
          supply_proceeding_for @hearing
          
          supply @hearing, :court,   parse: [:name],  factory: { strategy: :find }
          supply @hearing, :section, parse: [:value], factory: { type: HearingSection }
          supply @hearing, :subject, parse: [:value], factory: { type: HearingSubject }
          supply @hearing, :form,    parse: [:value], factory: { type: HearingForm }
          
          yield
        end
      end
      
      def judges
        names = @parser.judges(@document)
        
        unless names.empty?
          puts "Processing #{pluralize names.count, 'judge'}."
          
          names.each do |name|
            match_judges_by(name) do |similarity, judge|
              judging(judge, similarity, name, false)
            end
          end
        end
      end
      
      private
      
      def judging(judge, similarity, name, chair)
        judging = judging_by_judge_id_and_hearing_id_factory.find_or_create(judge.id, @hearing.id)
        
        judging.judge                  = judge
        judging.judge_name_similarity  = similarity
        judging.judge_name_unprocessed = name[:unprocessed]
        judging.judge_chair            = chair

        judging.hearing = @hearing
        
        @persistor.persist(judging)
      end
    end
  end
end
