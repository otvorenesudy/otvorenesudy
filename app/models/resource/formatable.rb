module Resource::Formatable
  extend ActiveSupport::Concern

  module ClassMethods
    def formatters
      @formatters ||= Hash.new
    end

    protected

    def formatable(attribute, options = {})
      define_method attribute do |pattern = nil|
        value = read_attribute(attribute)

        return value if !value.nil? && (pattern.nil? || pattern == options[:default])

        formatter = (self.class.formatters[attribute] ||= Formatter.new data = yield(self), options)
        cache     = (formatted[attribute] ||= Cache.new data || yield(self))

        cache.get formatter, pattern
      end

      define_method "invalidate_#{attribute}" do
        formatted[attribute] = nil
      end
    end
  end

  private

  def formatted
    @formatted ||= {}
  end

  public

  class Formatter
    attr_reader :default,
                :directives,
                :fixes

    def initialize(data, options = {})
      @default    = options[:default] || raise
      @directives = data.keys.map { |key| key[1].to_sym }
      @fixes      = Array.wrap options[:fixes]
      @regexp     = /\%[#{@directives.join}]/
    end

    def format(pattern, data)
      value = (pattern || default).gsub(@regexp, data).squeeze(' ').strip

      @fixes.each { |fix| value = fix.call value }

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
