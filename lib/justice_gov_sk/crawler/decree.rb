# TODO consider reseting matched judges, i.e. judgements when updating 

module JusticeGovSk
  class Crawler
    class Decree < JusticeGovSk::Crawler
      attr_accessor :form_code
      
      def initialize(options = {})
        super(options)
        
        @form_code = options[:decree_form_code]
      end
      
      protected
      
      include JusticeGovSk::Helper::JudgeMatcher
      include JusticeGovSk::Helper::ProceedingSupplier
      
      def process(request)
        raise "Decree form code not set" unless @form_code

        super do
          uri = JusticeGovSk::Request.uri(request)
          
          @decree = decree_by_uri_factory.find_or_create(uri)

          @decree.form = decree_form_by_code_factory.find(@form_code)
        
          raise "Decree form not found" unless @decree.form
          
          @decree.uri  = uri
          @decree.text = fulltext(uri)
  
          @decree.case_number = @parser.case_number(@document)
          @decree.file_number = @parser.file_number(@document)
          @decree.date        = @parser.date(@document)
          @decree.ecli        = @parser.ecli(@document)
          
          supply_proceeding_for @decree
          
          supply @decree, :court, parse: [:name], factory: { strategy: :find }
          
          judge
          
          supply @decree, :nature, parse: [:value], factory: { type: DecreeNature }
          
          supply @decree, :legislation_area, parse: [:value]
          supply @decree, :legislation_subarea, { parse: [:value],
            defaults: { legislation_area: @decree.legislation_area }
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
        
        path = agent.storage.fullpath(agent.uri_to_path uri)
        
        JusticeGovSk::Extractor::Text.extract(path)
      end
      
      def images
        # TODO
      end
      
      def judge
        name = @parser.judge(@document)
        
        unless name.nil?
          match_judges_by(name) do |similarity, judge|
            judgement(judge, similarity, name)
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
        judgement = judgement_by_judge_id_and_decree_id_factory.find_or_create(judge.id, @decree.id)
        
        judgement.judge                  = judge
        judgement.judge_name_similarity  = similarity
        judgement.judge_name_unprocessed = name[:unprocessed]

        judgement.decree = @decree
        
        @persistor.persist(judgement)
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
