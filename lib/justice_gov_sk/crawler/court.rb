module JusticeGovSk
  class Crawler
    class Court < JusticeGovSk::Crawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::Court.new, persistor)
      end
      
      protected
      
      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)
          
          unless JusticeGovSk::URL.valid? uri
            puts "Invalid URI, court rejected."
            return nil
          end
          
          @court = court_by_uri_factory.find_or_create(uri)
          
          @court.uri = uri
             
          @court.name        = @parser.name(@document)
          @court.street      = @parser.street(@document)
          @court.phone       = @parser.phone(@document)
          @court.fax         = @parser.fax(@document)
          @court.media_phone = @parser.media_phone(@document)
          @court.latitude    = @parser.latitude(@document)
          @court.longitude   = @parser.longitude(@document)
          
          media_person = @parser.media_person(@document)
          
          unless media_person.nil?
            @court.media_person             = media_person[:name]
            @court.media_person_unprocessed = media_person[:name_unprocessed]
          end
      
          type
          municipality
          
          information_center
          registry_center
          business_registry_center
          
          @court
        end
      end
      
      def type
        value = @parser.type(@document)
        
        unless value.nil?
          type = court_type_by_value_factory.find_or_create(value)
          
          type.value = value
          
          @persistor.persist(type) if type.id.nil?
          
          @court.type = type          
        end
      end
      
      def municipality
        name    = @parser.municipality_name(@document)
        zipcode = @parser.municipality_zipcode(@document)
        
        unless name.nil? || zipcode.nil?
          municipality = municipality_by_name_factory.find_or_create(name)
          
          municipality.name    = name
          municipality.zipcode = zipcode
          
          @persistor.persist(municipality) if municipality.id.nil?
          
          @court.municipality = municipality
        end
      end
      
      def information_center
        @court.information_center = office CourtOfficeType.information_center, @court.information_center
      end
      
      def registry_center
        @court.registry_center = office CourtOfficeType.registry_center, @court.registry_center
      end
      
      def business_registry_center
        @court.business_registry_center = office CourtOfficeType.business_registry_center, @court.business_registry_center
      end

      private
      
      def office(type, office)
        email = @parser.office_email(type, @document)
        phone = @parser.office_phone(type, @document)
        hours = @parser.office_hours(type, @document)
        note  = @parser.office_note(type, @document)

        unless email.nil? && phone.nil? && hours.nil? && note.nil?
          office ||= court_office_factory.create
          
          office.court = @court
          office.type  = type
          
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
