# frozen_string_literal: true

module Probe
  class Facets
    # One facet of a search: its selected terms, the params that select or deselect each value, and the values with
    # their counts once the search has run.
    class Facet
      # A value of the facet and how many results have it. Results are equal when their values are.
      class Result
        attr_accessor :value, :count, :add_params, :remove_params, :selected

        def initialize(value, count, add_params, remove_params, selected)
          @value = value
          @count = count
          @add_params = add_params
          @remove_params = remove_params
          @selected = selected
        end

        # The params of the listing with this value selected.
        def params
          add_params
        end

        def selected?
          selected ? true : false
        end

        def eql?(other)
          other.is_a?(Result) && value.eql?(other.value)
        end

        alias == eql?

        delegate :hash, to: :value
      end

      attr_accessor :params
      attr_reader :base, :name, :field, :type, :view, :options, :terms, :results

      def initialize(name, field, options)
        @base = options[:base]
        @name = name.to_sym
        @field = field
        @type = options[:type]
        @size = options.fetch(:size, 5)
        @visible = options.fetch(:visible, true)
        @view = options[:view] || {}
        @options = options
        @terms = []
        @params = {}
        @results = []
      end

      def id
        "#{base}-#{name}".dasherize.downcase
      end

      def key
        "facets.#{base.to_s.underscore}.#{name}"
      end

      def size
        @size.respond_to?(:call) ? @size.call : @size
      end

      def terms=(value)
        @terms = Array.wrap(value)
      end

      def parse_terms(values)
        Array.wrap(values).map { |value| block_given? ? yield(value) : value.to_s }
      end

      def active?
        terms.present?
      end

      def visible?
        @visible ? true : false
      end

      def buildable?
        respond_to?(:aggregation)
      end

      def abstract?
        false
      end

      def suggestable?
        respond_to?(:suggest_aggregation)
      end

      def keyword_field
        Probe::Fields.keyword(field)
      end

      def analyzed_field
        Probe::Fields.analyzed(field)
      end

      # The facet's aggregation response: its values, and the selected values counted separately so they stay listed
      # (first) when they fall outside the top values.
      def populate(response)
        results = build_results(response)
        results.each { |result| result.selected = true if terms.include?(result.value) }

        selected = build_selected(response)
        selected.each { |result| result.selected = true }

        @results = (selected.reject { |result| results.include?(result) } + results).uniq
      end

      private

      def build_selected(_response)
        []
      end

      def result(value, count)
        self.class::Result.new(value, count, add_params(value), remove_params(value), false)
      end

      def add_params(value)
        values = Array.wrap(params[name])

        return params if values.include?(value)

        params.merge(name => params[name] ? values + [value] : value)
      end

      def remove_params(value)
        params.merge(name => params[name] ? Array.wrap(params[name]) - [value] : value)
      end
    end
  end
end
