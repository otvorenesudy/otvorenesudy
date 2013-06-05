module Document::Facets
  class Facet
    include Document::Index::Helpers

    attr_accessor :base,
                  :name,
                  :field,
                  :type,
                  :alias,
                  :size,
                  :terms,
                  :values,
                  :selected

    attr_accessor :highlight,
                  :visible,
                  :collapsible,
                  :collapsed,
                  :abstract,
                  :countless

    def initialize(name, field, options)
      @base        = options[:base]
      @name        = name
      @field       = field
      @type        = options[:type]
      @alias       = options[:as]
      @size        = options[:size] || 10
      @selected    = Array.new

      @highlight   = options[:highlight].nil? ? false : true
      @visible     = options[:visible].nil? ? true : options[:visible]
      @collapsible = options[:collapsible].nil? ? true : options[:collapsible]
      @collapsed   = options[:collapsed].nil? ? false : options[:collapsed]
      @abstract    = options[:abstract].nil? ? false : options[:abstract]
      @countless   = options[:countless].nil? ? false : options[:countless]
    end

    def id
      @id ||= "#{base.to_s.downcase}-#{name}"
    end

    def key
      @key ||= "facets.#{base.to_s.downcase}.#{name}"
    end

    def terms
      @terms = [] if @terms.nil?

      @terms
    end

    def terms?
      @terms.present?
    end

    def refresh!
      @selected = []
      @terms    = []
    end

    def populate(results)
      results = yield results if block_given?
      results = format_facets(results)

      results.concat format_facets(selected) if selected

      @values = results.map(&:symbolize_keys)
    end

    def values
      @values.map! do |data|
        data = yield data if block_given?

        if @alias
          data[:alias] = @alias.call data[:value]
        else
          data[:alias] = localize(data[:value])
        end

        data[:value]   = data[:value].to_s
        data[:alias] ||= data[:value]

        if @countless
          data.slice(:value, :alias)
        else
          data.slice(:value, :count, :alias)
        end
      end

      @values
    end

    def parse(values)
      values = [values] unless values.respond_to? :each

      values = values.map { |value| yield value } if block_given?

      values
    end

    alias :highlighted?   :highlight
    alias :visible?       :visible
    alias :collapsible?   :collapsible
    alias :collapsed?     :collapsed
    alias :abstract?      :abstract
    alias :countless?     :countless

    private

    def localize(value)
      translation = I18n.t "#{key}.#{value}", default: "_missing"

      return if translation == "_missing"

      translation
    end

    def format_value(value)
      value
    end

    def converter_for(type)
      case
      when type == Fixnum then Document::Converters::Numeric
      when type == Date   then Document::Converters::Date
      else                raise "No converter found for type #{type}."
      end
    end
  end
end
