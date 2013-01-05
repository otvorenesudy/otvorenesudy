module JusticeGovSk
  class Crawler
    class Hearing < JusticeGovSk::Crawler
      include JusticeGovSk::Helper::JudgeMatcher
      include JusticeGovSk::Helper::ProceedingSupplier
      
      protected
    
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
          
          court
          
          section
          subject
          form
          
          yield
        end
      end
      
      def court
        name = @parser.court(@document)
        
        @hearing.court = court_by_name_factory.find(name) unless name.nil?
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
      
      def section
        value = @parser.section(@document)
        
        unless value.nil?
          section = hearing_section_by_value_factory.find_or_create(value)
          
          section.value = value
          
          @persistor.persist(section) if section.id.nil?
          
          @hearing.section = section
        end
      end
      
      def subject
        value = @parser.subject(@document)
        
        unless value.nil?
          subject = hearing_subject_by_value_factory.find_or_create(value)
          
          subject.value = value
          
          @persistor.persist(subject) if subject.id.nil?
          
          @hearing.subject = subject
        end
      end
      
      def form
        value = @parser.form(@document)
        
        unless value.nil?
          form = hearing_form_by_value_factory.find_or_create(value)
          
          form.value = value
          
          @persistor.persist(form) if form.id.nil?
          
          @hearing.form = form          
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
        
        @persistor.persist(judging) if judging.id.nil?
      end
    end
  end
end
