require 'classes/string'
require 'nokogiri'

class HtmlParser < Parser
  def parse(content)
    clear_caches if self.respond_to? :clear_caches
    
    content = content.encode Encoding::UTF_8, encoding(content)
  
    Nokogiri::HTML::parse(content)
  end
  
  protected
  
  def find_value(name, element, selector, options = {}, &block)
    puts "Parsing #{name}."
    
    value = selector.blank? ? element : element.search(selector)
    
    unless value.nil?
      unless value.respond_to?(:empty?) && value.empty?
        #unless value.respond_to?(:text) && value.text.blank?
        
          value = block.call(value) if block
        
          return value
        #else
        #  puts "#{name.upcase_first} text blank."
        #end
      else
        puts "#{name.upcase_first} empty."
      end
    else
      puts "#{name.upcase_first} not present."
    end
    
    nil
  end
  
  def find_values(name, element, selector, &block)
    find_value(name, element, selector, &block) || []
  end
  
  private
  
  def encoding(content)
    part = ''
    
    content.bytes do |b|
      part << b
      part.scan(/charset="?[\w\d\-]+"\z/i) { |m| return m.gsub(/"/, '')[8..-1] }
    end
    
    Encoding::UTF_8
  end
end
