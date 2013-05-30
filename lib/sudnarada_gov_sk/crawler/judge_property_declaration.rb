module SudnaradaGovSk
  class Crawler
    class JudgePropertyDeclaration < SudnaradaGovSk::Crawler
      attr_accessor :court_name
      
      def initialize(options = {})
        super(options)
        
        @court_name = options[:court_name]
      end
      
      protected
      
      include JusticeGovSk::Helper::JudgeMaker
      include JusticeGovSk::Helper::JudgeMatcher
      
      def process(request)
        super do
          uri = SudnaradaGovSk::Request.uri(request)
          
          return nil unless SudnaradaGovSk::URL.valid? uri
          
          year       = @parser.year(@document)
          court      = court_by_name_factory.find(request.respond_to?(:court) ? request.court : @court_name)
          judge_name = @parser.judge(@document)
          judges_map = match_judges_by(judge_name, unaccet: true)
          
          most_similar_judges = judges_map[judges_map.keys.sort.last]

          if most_similar_judges.count == 1
            judge = most_similar_judges.first
          else
            judge = make_judge(uri, SudnaradaGovSk.source, judge_name, court: court)
          end
          
          @declaration = judge_property_declaration_by_year_and_judge_id_factory.find_or_create(year, judge.id)
          
          @declaration.uri    = uri
          @declaration.source = SudnaradaGovSk.source
          
          @declaration.court = court
          @declaration.judge = judge
          
          @declaration.year = year
          
          property_lists
          incomes
          related_persons
          statements
          
          @declaration
        end
      end
      
      private
      
      def property_lists
        lists = @parser.property_lists(@document)
    
        unless lists.blank?
          puts "Processing #{pluralize lists.count, 'property list'}."
          
          lists.each do |list|
            category = judge_property_category_by_value_factory.find_or_create(list[:category])
            
            category.value = list[:category]
            
            @persistor.persist(category)
            
            property_list = judge_property_list_by_judge_property_declaration_id_and_judge_property_category_id_factory.find_or_create(@declaration.id, category.id)

            property_list.declaration = @declaration
            property_list.category    = category

            puts "Deleting existing properties ... done (#{property_list.items.count})"
            
            property_list.items = []

            @persistor.persist(property_list)

            puts "Processing #{pluralize list.count, 'property'}."

            list[:properties].each do |data|
              property = judge_property_factory.create
              
              property.list = property_list
              
              supply(property, :acquisition_reason, defaults: { value: data[:acquisition_reason] }, factory: { type: JudgePropertyAcquisitionReason }) if data[:acquisition_reason]
              supply(property, :ownership_form,     defaults: { value: data[:ownership_form]     }, factory: { type: JudgePropertyOwnershipForm     }) if data[:ownership_form]
              supply(property, :change,             defaults: { value: data[:change]             }, factory: { type: JudgePropertyChange            }) if data[:change]
              
              property.description      = data[:description]
              property.acquisition_date = data[:acquisition_date]
              property.cost             = data[:cost]
              property.share_size       = data[:share_size]
              
              @persistor.persist(property)
            end
          end
        end
      end
      
      def incomes
        list = @parser.incomes(@document)
    
        unless list.blank?
          puts "Processing #{pluralize list.count, 'income'}."
          
          list.each do |data|
            income = judge_income_by_judge_property_declaration_id_and_description_factory.find_or_create(@declaration.id, data[:description])

            income.property_declaration = @declaration            
            income.description          = data[:description]
            income.value                = data[:value] 
            
            @persistor.persist(income)
          end
        end
      end
      
      def related_persons
        list = @parser.related_persons(@document)
    
        unless list.blank?
          puts "Processing #{pluralize list.count, 'related person'}."
          
          list.each do |data|
            person = judge_related_person_by_judge_property_declaration_id_and_name_factory.find_or_create(@declaration.id, data[:name][:altogether])
            
            person.property_declaration = @declaration
            person.name                 = data[:name][:altogether]
            person.institution          = data[:institution]
            person.function             = data[:function]
            
            @persistor.persist(person)
          end
        end
      end
      
      def statements
        list = @parser.statements(@document)
        
        unless list.blank?
          puts "Processing #{pluralize list.count, 'statement'}."
          
          list.each do |value|
            statement = judge_statement_by_value_factory.find_or_create(value)

            statement.value = value            
            
            @persistor.persist(statement)
            
            proclaim = judge_proclaim_by_judge_property_declaration_id_and_judge_statement_id_factory.find_or_create(@declaration.id, statement.id)

            proclaim.property_declaration = @declaration
            proclaim.statement            = statement
            
            @persistor.persist(proclaim)
          end
        end
      end
    end
  end
end
