class CourtCrawler < Crawler
  include Factories
  include Identify
  include Pluralize
  
  def initialize(downloader, persistor)
    super(downloader, CourtParser.new, persistor)
  end
  
  protected

  def process(uri, content)
    document = @parser.parse(content)
    
    unless uri.start_with? 'http://www.justice.gov.sk'
      puts "Invalid URI, court rejected."
      
      return nil
    end
    
    @court = court_factory.find_or_create(uri)
    
    @court.uri          = uri    
    @court.name         = @parser.name(document)
    @court.street       = @parser.street(document)
    @court.phone        = @parser.phone(document)
    @court.fax          = @parser.fax(document)
    @court.media_person = @parser.media_person(document)
    @court.media_phone  = @parser.media_phone(document)
    @court.latitude     = @parser.latitude(document)
    @court.longitude    = @parser.longitude(document)

    type(document)
    municipality(document)
    
    @persistor.persist(@court)
  end
  
  def type(document)
    value = @parser.type(document)
    
    type = court_type_factory.find_or_create(value)
    
    type.value = value
    
    @persistor.persist(type) if type.id.nil?
    
    @court.type = type
  end
  
  def municipality(document)
    name    = @parser.municipality_name(document)
    zipcode = @parser.municipality_zipcode(document)
    
    municipality = municipality_factory.find_or_create(name)
    
    municipality.name    = name
    municipality.zipcode = zipcode
    
    @persistor.persist(municipality) if municipality.id.nil?
    
    @court.municipality = municipality
  end
end
