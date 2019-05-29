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
                  :params,
                  :visible,
                  :view

    def initialize(name, field, options)
      @base    = options[:base]
      @name    = name
      @field   = field
      @type    = options[:type]
      @size    = options[:size] || 5
      @visible = options[:visible].nil? ? true : !!options[:visible]
      @view    = options[:view] || Hash.new
    end

    def id
      @id ||= name.to_s.dasherize.downcase
    end

    def key
      @key ||= "facets.#{base.to_s.underscore}.#{name}"
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

    def parse_terms(values)
      values = Array.wrap(values)

      values = values.map do |value|
        if block_given?
          yield value
        else
          value.to_s
        end
      end

      values
    end

    def active?
      @terms.present?
    end

    def visible?
      @visible
    end

    alias :collapsible? :visible?

    def buildable?
      respond_to? :build
    end

    def abstract?
      false
    end

    def suggestible?
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
      # TODO: refactor facets to user only add params
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
