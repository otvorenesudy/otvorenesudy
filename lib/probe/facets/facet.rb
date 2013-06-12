class Probe::Facets
  class Facet
    include Probe::Helpers::Index

    attr_accessor :base,
                  :name,
                  :field,
                  :type,
                  :size,
                  :terms,
                  :results,
                  :params

    attr_accessor :highlight,
                  :visible,
                  :collapsible,
                  :sortable,
                  :collapsed,
                  :countless

    def initialize(name, field, options)
      @base        = options[:base]
      @name        = name
      @field       = field
      @type        = options[:type]
      @alias       = options[:as]
      @size        = options[:size] || 10

      @highlight   = options[:highlight].nil? ? false : options[:highlight]
      @visible     = options[:visible].nil? ? true : options[:visible]
      @collapsible = options[:collapsible].nil? ? true : options[:collapsible]
      @collapsed   = options[:collapsed].nil? ? false : options[:collapsed]
      @countless   = options[:countless].nil? ? false : options[:countless]
    end

    def id
      @id ||= "#{base.to_s.downcase}-#{name}"
    end

    def key
      @key ||= "facets.#{base.to_s.downcase}.#{name}"
    end

    def params
      @params ||= {}
    end

    def populate(results, selected)
      results = yield results if block_given?

      results = populate_facets(results)

      if selected
        selected = populate_facets(selected).find_all { |e| @terms.include? e.value }

        results.each do |result|
          result.selected = true if active? && @terms.include?(result.value)

          selected -= [result]
        end

        unless selected.empty?
          results.unshift(*selected)
        end
      end

      @results = results.uniq
    end

    def parse_terms(values)
      values = [values] unless values.respond_to? :each

      values = values.map { |value| yield value } if block_given?

      values
    end

    alias :highlighted?   :highlight
    alias :visible?       :visible
    alias :collapsible?   :collapsible
    alias :collapsed?     :collapsed
    alias :countless?     :countless

    def active?
      @terms.present?
    end

    def buildable?
      respond_to? :build
    end

    def selected_name
      "#{@name}_selected"
    end

    def suggest_name
      "#{@name}_suggest"
    end

    def missing_facet_name
      "missing"
    end

    def analyzed_field_name
      analyzed_field(@field)
    end

    def not_analyzed_field_name
      not_analyzed_field(@field)
    end

    def refresh!
      @terms = []
    end

    private

    def converter_for(type)
      case
      when type == Fixnum then Probe::Converters::Numeric
      when type == Date   then Probe::Converters::Date
      else                raise "No converter found for type #{type}."
      end
    end

    def create_result_params(value)
      params.merge @name => [value]
    end

    def create_result_add_params(value)
      values = params[@name] ? params[@name] + [value] : [value]

      params.merge @name => values
    end

    def create_result_remove_params(value)
      values = params[@name] ? params[@name] - [value] : [value]

      params.merge @name => values
    end

    class Result < Struct.new(:value, :count, :params, :add_params, :remove_params, :selected)
      def selected?
        selected
      end

      def missing?
        value.nil? || value == missing_facet_name
      end

      def eql?(result)
        value.eql? result.value
      end

      def hash
        value.hash
      end
    end
  end
end
