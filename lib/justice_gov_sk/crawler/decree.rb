module JusticeGovSk
  class Crawler
    class Decree < JusticeGovSk::Crawler
      attr_accessor :form_code
      
      def initialize(options = {})
        super(options)
        
        @form_code = options[:decree_form_code]
      end
      
      protected
      
      include JusticeGovSk::Helper::ContentValidator
      include JusticeGovSk::Helper::JudgeMatcher
      include JusticeGovSk::Helper::ProceedingSupplier
      include JusticeGovSk::Helper::UpdateController::Instance
      
      def process(request)
        raise "Decree form code not set" unless @form_code

        super do
          uri = JusticeGovSk::Request.uri(request)
          
          @decree = decree_by_uri_factory.find_or_create(uri)
          
          next @decree unless crawlable?(@decree)
          
          @decree.form = decree_form_by_code_factory.find(@form_code)
          
          raise "Decree form not found" unless @decree.form
          
          @decree.uri    = uri
          @decree.source = JusticeGovSk.source
          
          fulltext(uri)
          
          @decree.case_number = @parser.case_number(@document)
          @decree.file_number = @parser.file_number(@document)
          @decree.date        = @parser.date(@document)
          @decree.ecli        = @parser.ecli(@document)
          
          supply_proceeding_for @decree
          
          supply @decree, :court, parse: :name, factory: { strategy: :find }
          
          judge
          
          natures
          
          supply @decree, :legislation_area, parse: :value
          supply @decree, :legislation_subarea, { parse: :value,
            defaults: { area: @decree.legislation_area },
            factory: { args: :value }
          }
          
          legislations

          @decree          
        end
      end
      
      def fulltext(uri)
        request = inject JusticeGovSk::Request, implementation: Decree, suffix: :Document
        agent   = inject JusticeGovSk::Agent,   implementation: Decree, suffix: :Document
        
        request.url = uri
        
        agent.download(request)
        
        path = agent.storage.path(agent.uri_to_path uri)
        
        if valid_content? path, :decree_pdf
          configuration = JusticeGovSk::Configuration.extractor
          
          # TODO refactor .map(&:constantize) -> see bugs in settingslogic & custom config YML files
          if configuration.text.perform.map(&:constantize).include? @decree.class
            if configuration.text.override.map(&:constantize).include?(@decree.class) || @decree.text.blank? 
              @decree.text = JusticeGovSk::Extractor::Text.extract(path)
            end
          end
          
          storage = JusticeGovSk::Storage::DecreeImage.instance
          options = { output: storage.path(@decree.document_entry) }
          
          if configuration.image.perform.map(&:constantize).include? @decree.class
            if configuration.image.override.map(&:constantize).include?(@decree.class) || !storage.contains?(options[:output])
              JusticeGovSk::Extractor::Image.extract(@decree.document_path, options)
            end
          end
        end
      end
      
      def judge
        name = @parser.judge(@document)
        
        unless name.nil?
          match_judges_by(name) do |similarity, judge|
            judgement(judge, similarity, name)
          end
        end
      end
      
      def natures
        list = @parser.natures(@document)
        
        unless list.blank?
          puts "Processing decree #{pluralize list.count, 'nature'}."
          
          list.each do |value|
            nature = decree_nature_factory.find_or_create(value)
            
            nature.value = value
            
            @persistor.persist(nature)
            
            naturalization(nature)
          end
        end
      end
      
      def legislations
        list = @parser.legislations(@document)
    
        unless list.blank?
          puts "Processing #{pluralize list.count, 'legislation'}."
          
          list.each do |item|
            identifiers = @parser.legislation(item)
            
            unless identifiers.empty?
              value = identifiers[:value]
              
              legislation = legislation_by_value_factory.find_or_create(value)
              
              legislation.value             = value
              legislation.value_unprocessed = item
              
              legislation.number    = identifiers[:number] 
              legislation.year      = identifiers[:year]
              legislation.name      = identifiers[:name]
              legislation.paragraph = identifiers[:paragraph]
              legislation.section   = identifiers[:section]
              legislation.letter    = identifiers[:letter]
              
              @persistor.persist(legislation)
              
              legislation_usage(legislation)
            end
          end
        end
      end
      
      private
      
      def judgement(judge, similarity, name)
        if judge
          judgement = judgement_by_decree_id_and_judge_id_factory.find_or_create(@decree.id, judge.id)
        else
          judgement = partial_judgement_by_decree_id_and_judge_name_factory.find_or_create(@decree.id, name[:altogether])
        end
        
        judgement.judge                  = judge             if judgement.is_a? Judgement 
        judgement.judge_name             = name[:altogether] if judgement.is_a? PartialJudgement
        judgement.judge_name_similarity  = similarity        if judgement.is_a? Judgement
        judgement.judge_name_unprocessed = name[:unprocessed]

        judgement.decree = @decree
        
        @persistor.persist(judgement)
      end
      
      def naturalization(nature)
        naturalization = decree_naturalization_by_decree_id_and_decree_nature_id_factory.find_or_create(@decree.id, nature.id)
        
        naturalization.decree = @decree
        naturalization.nature = nature
        
        @persistor.persist(naturalization)
      end
      
      def legislation_usage(legislation)
        legislation_usage = legislation_usage_by_legislation_id_and_decree_id_factory.find_or_create(legislation.id, @decree.id)
        
        legislation_usage.legislation = legislation
        legislation_usage.decree      = @decree
        
        @persistor.persist(legislation_usage)
      end
    end
  end
end
