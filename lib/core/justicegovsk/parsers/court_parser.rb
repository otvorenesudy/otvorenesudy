class CourtParser < HtmlParser
  def type(document)
    name(document).split(/\s/)[0]
  end
  
  def municipality_name(document)
    value document, 'div.DetailTable div.hodnota', 'municipality name' do |divs|
      divs[3].text.strip
    end
  end
  
  def municipality_zipcode(document)
    value document, 'div.DetailTable div.hodnota', 'municipality zipcode' do |divs|
      divs[2].text.strip
    end
  end
  
  def name(document)
    return @name unless @name.nil?
    
    value document, 'div.sprava h1', 'name' do |h1|
      @name ||= h1.text.strip
    end
  end
  
  def street(document)
    value document, 'div.DetailTable div.hodnota', 'street' do |divs|
      divs[1].text.strip
    end
  end
  
  def phone(document)
    value document, 'div.DetailTable div.hodnota', 'phone' do |divs|
      divs[4].text.strip
    end    
  end
 
  def fax(document)
    value document, 'div.DetailTable div.hodnota', 'fax' do |divs|
      divs[5].text.strip
    end    
  end
  
  def media_person(document)
    value document, 'div.DetailTable div.hodnota', 'media person' do |divs|
      divs[6].text.strip
    end 
  end
  
  def media_phone(document)
    value document, 'div.DetailTable div.hodnota', 'media phone' do |divs|
      divs[7].text.strip
    end 
  end
  
  def latitude(document)
    coordinates(document)[:latitude]
  end
  
  def longitude(document)
    coordinates(document)[:longitude]
  end
  
  private
  
  def coordinates(document)
    return @coordinates unless @coordinates.nil? 
    
    value document, 'div.textInfo iframe', 'fax' do |iframe|
      @coordinates = {}
      
      iframe[0][:src].scan(/sll=(\d+\.\d{5})\,(\d+\.\d{5})/) do |latitude, longitude|
        @coordinates[:latitude]  = latitude.sub(/\./)
        @coordinates[:longitude] = longitude.sub(/\./)
      end
      
      @coordinates
    end
  end
end
