module JusticeGovSk
  class Crawler
    class Court < JusticeGovSk::Crawler
      protected
      
      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)
          
          return nil unless JusticeGovSk::URL.valid? uri
          
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
          
          supply @court, :type, parse: [:value], factory: { type: CourtType }
          supply @court, :municipality, parse: [:name, :zipcode], factory: { args: [:name] }
          
          information_center
          registry_center
          business_registry_center
          
          @court
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
