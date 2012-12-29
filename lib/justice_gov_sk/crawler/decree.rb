module JusticeGovSk
  module Crawler
    class Decree < JusticeGovSk::Crawler
      attr_accessor :form_code
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::Decree.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
                
        @decree = decree_factory.find_or_create(uri)
        
        @decree.uri  = uri
        @decree.text = fulltext(uri)

        @decree.case_number = @parser.case_number(document)
        @decree.file_number = @parser.file_number(document)
        @decree.date        = @parser.date(document)
        @decree.ecli        = @parser.ecli(document)
        
        proceeding(document)
        
        court(document)
        judge(document)
        
        form(document)
        nature(document)
        
        legislation_area(document)
        legislation_subarea(document)
        
        legislations(document)
        
        @persistor.persist(@decree)
      end
      
      def fulltext(uri)
        storage = JusticeGovSk::Storages::DecreeDocumentStorage.new
        request = JusticeGovSk::Requests::DocumentRequest.new
        agent   = JusticeGovSk::Agents::DocumentAgent.new
        
        agent.cache_load_and_store = true
        agent.cache_root           = storage.root
        agent.cache_binary         = storage.binary
        agent.cache_distribute     = storage.distribute
        agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :pdf

        request.url = uri

        agent.download(request)
        
        path = JusticeGovSk::Requests::URL.url_to_path uri, :pdf
        
        print "Extracting text ... "
        
        text = TextExtractor.new.extract(storage.fullpath path)
        
        puts "done (#{text.length} chars)"
        
        text
      end
      
      def proceeding(document)
        proceeding = proceeding_by_file_number_factory.find_or_create(@decree.file_number)
        
        proceeding.file_number = @decree.file_number
        
        @decree.proceeding = proceeding
          
        @persistor.persist(proceeding) if proceeding.id.nil?
      end
      
      def court(document)
        name = @parser.court(document)
        
        unless name.nil?
          court = court_by_name_factory.find(name)
          
          @decree.court = court
        end
      end
      
      # TODO DB: refactor judge to decree / hearing relations
      # - remove chair judge from decrees, add is_chair to judgings
      # - add binging table (Judgements for example) between decrees and judges
      #   with structure same as judgings
      # - remove matched_exactly, add similarity <- 3 gram sim. value by pgsql 
      
      # TODO make helper method for matching judges: decree, hearing & hearing chair_judge
      def judge(document)
        name = @parser.judge(document)
        
        unless name.nil?
          # TODO rm
          #judge = judge_factory { Judge.find :first, conditions: ['name LIKE ?', "#{name}%"] }.find(name)
          
          judge = judge_factory.find(name[:altogether])
          exact = nil
          
          unless judge.nil?
            exact = true
          # TODO refactor, see todos in decree crawler
          #else
          #  judge = judge_factory_by_last_and_middle_and_first(name[:names])
          #  exact = false unless judge.nil?
          end
          
          @decree.judge                  = judge
          @decree.judge_matched_exactly  = exact
          @decree.judge_name_unprocessed = name[:unprocessed]
        end
      end
      
      def form(document)
        raise "Decree form code not set" if @form_code.nil?
        
        form = decree_form_by_code_factory.find(@form_code)
        
        raise "Decree form not found" if form.nil?
        
        @decree.form = form
      end
      
      def nature(document)
        value = @parser.nature(document)
        
        unless value.nil?
          nature = decree_nature_factory.find_or_create(value)
          
          nature.value = value
          
          @persistor.persist(nature) if nature.id.nil?
          
          @decree.nature = nature          
        end
      end
        
      def legislation_area(document)
        value = @parser.legislation_area(document)
        
        unless value.nil?
          legislation_area = legislation_area_factory.find_or_create(value)
          
          legislation_area.value = value
          
          @persistor.persist(legislation_area) if legislation_area.id.nil?
          
          @decree.legislation_area = legislation_area          
        end
      end
      
      def legislation_subarea(document)
        value = @parser.legislation_subarea(document)
        
        unless value.nil?
          legislation_subarea = legislation_subarea_factory.find_or_create(value)

          legislation_area(document) if @decree.legislation_area.nil?
          
          legislation_subarea.area  = @decree.legislation_area
          legislation_subarea.value = value
          
          @persistor.persist(legislation_subarea) if legislation_subarea.id.nil?
          
          @decree.legislation_subarea = legislation_subarea          
        end
      end
        
      def legislations(document)
        list = @parser.legislations(document)
    
        unless list.blank?
          puts "Processing #{pluralize list.count, 'legislation'}."
          
          list.each do |item|
            identifiers = @parser.legislation(item)
            
            unless identifiers.empty?
              value = identifiers[:value]
              
              legislation = legislation_factory.find_or_create(value)
              
              legislation.value             = value
              legislation.value_unprocessed = item
              
              legislation.number    = identifiers[:number] 
              legislation.year      = identifiers[:year]
              legislation.name      = identifiers[:name]
              legislation.paragraph = identifiers[:paragraph]
              legislation.section   = identifiers[:section]
              legislation.letter    = identifiers[:letter]
              
              @persistor.persist(legislation) if legislation.id.nil?
              
              legislation_usage(legislation)
            end
          end
        end
      end
      
      private
      
      def legislation_usage(legislation)
        legislation_usage = legislation_usage_factory.find_or_create(legislation.id, @decree.id)
        
        legislation_usage.legislation = legislation
        legislation_usage.decree      = @decree
        
        @persistor.persist(legislation_usage) if legislation_usage.id.nil?
      end
    end
  end
end
