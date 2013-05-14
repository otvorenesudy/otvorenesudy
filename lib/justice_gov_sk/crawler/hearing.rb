module JusticeGovSk
  class Crawler
    class Hearing < JusticeGovSk::Crawler
      protected
    
      include JusticeGovSk::Helper::JudgeMatcher
      include JusticeGovSk::Helper::ProceedingSupplier
      include JusticeGovSk::Helper::UpdateController::Instance
      
      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)
          
          @hearing = hearing_by_uri_factory.find_or_create(uri)
          
          next @hearing unless crawlable?(@hearing)
          
          @hearing.uri    = uri
          @hearing.source = JusticeGovSk.source
  
          @hearing.case_number = @parser.case_number(@document)
          @hearing.file_number = @parser.file_number(@document)
          @hearing.date        = @parser.date(@document)
          @hearing.room        = @parser.room(@document)
          @hearing.note        = @parser.note(@document)
          
          supply_proceeding_for @hearing
          
          supply @hearing, :court,   parse: :name,  factory: { strategy: :find }
          supply @hearing, :section, parse: :value, factory: { type: HearingSection }
          supply @hearing, :subject, parse: :value, factory: { type: HearingSubject }
          supply @hearing, :form,    parse: :value, factory: { type: HearingForm }
          
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
        if judge
          judging = judging_by_hearing_id_and_judge_id_factory.find_or_create(@hearing.id, judge.id)
        else
          judging = partial_judging_by_hearing_id_and_judge_name_factory.find_or_create(@hearing.id, name[:altogether])
        end
        
        judging.judge                  = judge             if judging.is_a? Judging 
        judging.judge_name             = name[:altogether] if judging.is_a? PartialJudging
        judging.judge_name_similarity  = similarity        if judging.is_a? Judging
        judging.judge_name_unprocessed = name[:unprocessed]
        judging.judge_chair            = chair

        judging.hearing = @hearing
        
        @persistor.persist(judging)
      end
    end
  end
end
