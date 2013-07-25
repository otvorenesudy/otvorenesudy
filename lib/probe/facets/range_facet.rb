class Probe::Facets
  class RangeFacet < Probe::Facets::Facet
    def initialize(name, field, options)
      super(name, field, options)

      @ranges    = options[:ranges]
      @converter = options[:converter] || converter_for(@ranges.first.begin.class)
    end

    def build(name, options)
      options = prepare_build(options)

      options.merge! range: {
        field:  not_analyzed_field(@field),
        ranges: build_facet_ranges
      }

      { name => options }
    end

    def build_filter
      terms.map do |value|
        { range: { not_analyzed_field(@field) => build_range_for(value) }}
      end
    end

    def parse_terms(values)
      super(values) do |value|
        return value if value.is_a? Range

        lower, upper = value.split('..')

        result = @converter.to_elastic(lower)..@converter.to_elastic(upper)
        result = yield result if block_given?
        result
      end
    end

    private

    def build_range_for(value)
      @converter.to_elastic_range(value)
    end

    def build_facet_ranges
      ranges = []

      ranges << { to: @ranges.first.begin + 1 }

      @ranges.each do |range|
        ranges << { from: range.begin, to: range.end + 1 }
      end

      ranges << { from: @ranges.last.end }

      ranges
    end

    def populate_facets(results)
      results['ranges'].map { |range|
        next unless range['count'] > 0

        value = format_range(range['from'], range['to'])

        params        = create_result_params(value)
        add_params    = create_result_add_params(value)
        remove_params = create_result_remove_params(value)

        Result.new(value, range['count'], params, add_params, remove_params)
      }.compact
    end

    def format_range(from, to)
      case
      when from.nil? then -Float::INFINITY..(to.to_i - 1)
      when to.nil?   then from.to_i..Float::INFINITY
      else                from.to_i..(to.to_i - 1)
      end
    end

    class Result < Facet::Result
      def range
        value
      end
    end
  end
end
