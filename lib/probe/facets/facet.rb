class Probe::Facets
  class Facet
    include Probe::Helpers

    attr_accessor :base,
                  :name,
                  :field,
                  :type,
                  :size,
                  :terms,
                  :results,
                  :params

    def initialize(name, field, options)
      @base  = options[:base]
      @name  = name
      @field = field
      @type  = options[:type]
      @size  = options[:size] || 10
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

    def terms=(value)
      @terms = Array.wrap(value)
    end

    def prepare_build(options)
      facet_options = Hash.new

      facet_options.merge! global: options[:global], facet_filter: options[:facet_filter]
    end

    def populate(results, selected)
      results = yield results if block_given?
      results = populate_facets(results)

      if selected
        selected = populate_facets(selected).find_all { |e| @terms.include? e.value }

        selected.each { |e| e.selected = true }

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

    def parse_terms(terms)
      return unless terms.present?

      terms = Array.wrap(terms)

      terms = terms.map do |value|
        if block_given?
          yield value
        else
          value.to_s
        end
      end

      terms.compact
    end

    def active?
      @terms.present?
    end

    def buildable?
      respond_to? :build
    end

    def abstract?
      false
    end

    def suggestable?
      respond_to? :build_suggest_facet
    end

    def selected_name
      "#{@name}_selected"
    end

    def missing_facet_name
      'missing'
    end

    def refresh!
      @terms   = []
      @results = []
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
      # TODO: refactor facets to use only add params
      create_result_add_params(value)
    end

    def create_result_add_params(value)
      values = Array.wrap(params[@name])

      return params if values.include? value

      values = params[@name] ? values + [value] : value

      params.merge @name => values
    end

    def create_result_remove_params(value)
      values = params[@name] ? Array.wrap(params[@name]) - [value] : value

      params.merge @name => values
    end

    class Result < Struct.new(:value, :count, :params, :add_params, :remove_params, :selected)
      def selected?
        selected
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
