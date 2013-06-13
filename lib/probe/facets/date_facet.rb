class Probe::Facets
  class DateFacet < Probe::Facets::RangeFacet
    attr_accessor :interval

    def initialize(name, field, options)
      options[:converter] = Probe::Converters::Date

      super(name, field, options)

      @interval = options[:interval]
    end

    def build(index, name, options)
      index.facet name, options do |f|
        f.date not_analyzed_field(@field), interval: @interval
      end
    end

    private

    def populate_facets(results)
      results['entries'].map do |entry|
        value = format_date(entry['time'])

        params        = create_result_params(value)
        add_params    = create_result_add_params(value)
        remove_params = create_result_remove_params(value)

        Result.new(value, entry['count'], params, add_params, remove_params, @interval)
      end.reverse!
    end

    def format_date(value)
      date = @converter.from_elastic(value)

      case @interval
      when :month
        date.beginning_of_month..date.end_of_month
      end
    end

    class Result < RangeFacet::Result
      def initialize(value, count, params, add_params, remove_params, interval)
        super(value, count, params, add_params, remove_params)

        interval = interval
      end
    end
  end
end
