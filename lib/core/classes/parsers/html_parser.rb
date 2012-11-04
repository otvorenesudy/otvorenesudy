require 'classes/string'
require 'nokogiri'

class HtmlParser < Parser
  def parse(content)
    content = content.encode 'utf-8', encoding(content)
  
    Nokogiri::HTML::parse(content)
  end
  
  protected
  
  def value(element, selector, name, &block)
    puts "Parsing #{name}."
    
    value = selector.blank? ? element : element.css(selector)
    
    unless value.nil?
      unless value.respond_to?(:empty?) && value.empty?
        value = block.call(value) if block
        
        return value
      else
        puts "#{name.upcase_first} empty."
      end
    else
      puts "#{name.upcase_first} not present."
    end
    
    nil
  end
  
  def values(element, selector, name, &block)
    value(element, selector, name, &block) || []
  end
  
  private
  
  def encoding(content)
    part = ''
    
    content.bytes do |b|
      part << b
      part.scan(/charset="?[\w\d\-]+"\z/i) { |m| return m.gsub(/"/, '')[8..-1] }
    end
    
    'utf-8'
  end
end
