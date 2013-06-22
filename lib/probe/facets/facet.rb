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

    def initialize(name, field, options)
      @base        = options[:base]
      @name        = name
      @field       = field
      @type        = options[:type]
      @alias       = options[:as]
      @size        = options[:size] || 10
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

    def parse_terms(terms)
      if block_given?
        if terms.respond_to? :each
          terms = terms.map { |value| yield value }
        else
          terms = yield(terms)
        end
      end

      terms
    end

    def active?
      @terms.present?
    end

    def buildable?
      respond_to? :build
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

    def analyzed_field_name
      analyzed_field(@field)
    end

    def not_analyzed_field_name
      not_analyzed_field(@field)
    end

    def suggested_field_name
      suggested_field(@field)
    end

    def refresh!
      @terms  = []
      @script = nil
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
      #params.merge @name => value
      # TODO: refactor facets to user only add params
      create_result_add_params(value)
    end

    def create_result_add_params(value)
      values = params[@name] ? Array.wrap(params[@name]) + [value] : value

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
