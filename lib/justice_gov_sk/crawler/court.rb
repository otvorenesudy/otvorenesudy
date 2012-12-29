module JusticeGovSk
  module Crawler
    class Court < JusticeGovSk::Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::Court.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
        
        unless uri.start_with? JusticeGovSk::Requests::URL.base
          puts "Invalid URI, court rejected."
          
          return nil
        end
        
        @court = court_factory.find_or_create(uri)
        
        @court.uri = uri
           
        @court.name        = @parser.name(document)
        @court.street      = @parser.street(document)
        @court.phone       = @parser.phone(document)
        @court.fax         = @parser.fax(document)
        @court.media_phone = @parser.media_phone(document)
        @court.latitude    = @parser.latitude(document)
        @court.longitude   = @parser.longitude(document)
        
        media_person = @parser.media_person(document)
        
        unless media_person.nil?
          @court.media_person             = media_person[:name]
          @court.media_person_unprocessed = media_person[:name_unprocessed]
        end
    
        type(document)
        municipality(document)
        
        information_center(document)
        registry_center(document)
        business_registry_center(document)
        
        @persistor.persist(@court)
      end
      
      def type(document)
        value = @parser.type(document)
        
        unless value.nil?
          type = court_type_factory.find_or_create(value)
          
          type.value = value
          
          @persistor.persist(type) if type.id.nil?
          
          @court.type = type          
        end
      end
      
      def municipality(document)
        name    = @parser.municipality_name(document)
        zipcode = @parser.municipality_zipcode(document)
        
        unless name.nil? || zipcode.nil?
          municipality = municipality_factory.find_or_create(name)
          
          municipality.name    = name
          municipality.zipcode = zipcode
          
          @persistor.persist(municipality) if municipality.id.nil?
          
          @court.municipality = municipality
        end
      end
      
      def information_center(document)
        @court.information_center = office :information_center, @court.information_center, document
      end
      
      def registry_center(document)
        @court.registry_center = office :registry_center, @court.registry_center, document
      end
      
      def business_registry_center(document)
        @court.business_registry_center = office :business_registry_center, @court.business_registry_center, document
      end

      private
      
      def office(type, office, document)
        email = @parser.office_email(type, document)
        phone = @parser.office_phone(type, document)
        hours = @parser.office_hours(type, document)
        note  = @parser.office_note(type, document)

        unless email.nil? && phone.nil? && hours.nil? && note.nil?
          office ||= court_office_factory.create
          
          office.court = @court
          
          office.email = email
          office.phone = phone
          office.note  = note
          
          office.hours_monday    = hours[:monday]
          office.hours_tuesday   = hours[:tuesday]
          office.hours_wednesday = hours[:wednesday]
          office.hours_thursday  = hours[:thursday]
          office.hours_friday    = hours[:friday]
          
          return @persistor.persist(office)
        end
      end
    end
  end
end
