require 'classes/string'
require 'nokogiri'

class HtmlParser < Parser
  def parse(resource)
    clear_caches if self.respond_to? :clear_caches
    
    print "Parsing resource ... "
    
    if resource.is_a? Nokogiri::HTML::Document
      puts "done (already parsed)"
      
      document = resource
    else
      content  = resource.encode Encoding::UTF_8, encoding(resource)
      document = Nokogiri::HTML::parse(content)
      
      puts "done"
    end
  
    document
  end
  
  protected
  
  def find_value(name, element, selector, options = {}, &block)
    options = defaults.merge options
    
    puts "Parsing #{name}."
    
    value = selector.blank? ? element : element.search(selector)
    
    if options[:present?]
      if value.nil?
        puts "#{name.upcase_first} not present."
        return
      end
    end
    
    if options[:empty?]
      if value.respond_to?(:empty?) && value.empty?
        puts "#{name.upcase_first} empty."
        return
      end
        
      if value.respond_to?(:text) && value.text.empty?
        puts "#{name.upcase_first} text empty."
        return
      end
    end
    
    block_given? ? block.call(value) : value 
  end
  
  def find_values(name, element, selector, options = {}, &block)
    find_value(name, element, selector, options, &block) || []
  end
  
  private
  
  def defaults
    {
      present?: true,
      empty?:   true,
    }
  end
  
  def encoding(content)
    part = ''
    
    content.bytes do |b|
      part << b
      part.scan(/charset="?[\w\d\-]+"\z/i) { |m| return m.gsub(/"/, '')[8..-1] }
    end
    
    Encoding::UTF_8
  end
end
