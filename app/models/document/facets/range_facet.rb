module Document::Facets
  class RangeFacet < Document::Facets::Facet
    def initialize(name, field, options)
      super(name, field, options)

      @ranges    = options[:ranges]
      @converter = options[:converter] || converter_for(@ranges.first.begin.class)
      @alias     = method(:alias_range)
    end

    def build(facet)
      facet.range not_analyzed_field(@field), build_facet_ranges
    end

    def build_filter
      terms.map do |value|
        { range: { not_analyzed_field(@field) => build_range_for(value) } }
      end
    end

    def parse(values)
      super(values) do |value|
        lower, upper = value.split('..')

        @converter.to_elastic(lower)..@converter.to_elastic(upper)
      end
    end

    private

    def build_range_for(value)
      @converter.to_elastic_range(value)
    end

    def build_facet_ranges
      ranges = []

      ranges << { to: @ranges.first.begin }

      @ranges.each do |range|
        ranges << { from: range.begin, to: range.end }
      end

      ranges << { from: @ranges.last.end }

      ranges
    end

    def format_facets(results)
      results['ranges'].map do |e|
        format_entry(e)
      end
    end

    def format_entry(entry)
      { value: format_value(entry['from'], entry['to']), count: entry['count'] }
    end

    def format_value(from, to)
      case
      when from.nil? then -Float::INFINITY..to
      when to.nil?   then from..Float::INFINITY
      else                from..to
      end
    end

    def alias_range(range)
      params = Hash.new

      case
      when range.begin == -Float::INFINITY
        entry          = :less
        params[:count] = range.end.to_i
      when range.end == Float::INFINITY
        entry          = :more
        params[:count] = range.begin.to_i
      else
        entry          = :between
        params[:lower] = range.begin.to_i
        params[:upper] = range.end.to_i
      end

      count  = params[:count] || params[:upper]

      path   = "#{key}.#{entry}"
      suffix = "#{key}.suffix"

      if missing_translation?(path)
        path = "facets.types.range.#{entry}"
      end

      result = I18n.t(path, params)

      unless missing_translation?(suffix)
        result.sub!(/\d+\z/, I18n.t(suffix, count: count))
      end

      result
    end
  end
end
