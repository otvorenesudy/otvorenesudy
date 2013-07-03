module Resource::Formatable
  extend ActiveSupport::Concern

  module ClassMethods
    def formatters
      @formatters ||= {}
    end
    
    def formatable(attribute, options = {})
      define_method attribute do |pattern = nil|
        return super() if defined?(super) == true && (pattern.nil? || pattern == options[:default])
        
        formatter = (self.class.formatters[attribute] ||= Formatter.new data = yield(self), options)
        cache     = (formatted[attribute] ||= Cache.new data || yield(self))

        cache.get formatter, pattern
      end
    end
  end
  
  private
  
  def formatted
    @formatted ||= {}
  end

  class Formatter
    attr_reader :default,
                :directives,
                :remove,
                :squeeze,
                :strip

    def initialize(data, options = {})
      @default    = options[:default] || raise
      @directives = data.keys.map { |key| key[1].to_sym }
      @regexp     = /\%[#{@directives.join}]/
      
      @remove  = options[:remove]
      @squeeze = options[:squeeze] == false ? nil : options[:squeeze] || ' '
      @strip   = options[:strip] == nil ? true : options[:strip]
    end
    
    def format(pattern, data)
      value = (pattern || default).gsub(@regexp, data)
      
      value.gsub! @remove, '' if @remove
      value.squeeze! @squeeze if @squeeze
      value.strip! if @strip
      value
    end
  end
  
  class Cache
    attr_reader :values
    
    def initialize(data)
      @data  = data
      @cache = {}
    end
    
    def get(formatter, pattern)
      @cache[pattern] ||= formatter.format pattern, @data
    end
  end
end
