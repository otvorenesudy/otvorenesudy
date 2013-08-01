class Probe::Facets
  class DateFacet < Probe::Facets::RangeFacet
    attr_accessor :interval

    def initialize(name, field, options)
      options[:converter] = Probe::Converters::Date

      super(name, field, options)

      @interval = options[:interval]
    end

    def build(name, options)
      options = prepare_build(options)

      options.merge! date_histogram: {
        field: field,
        interval: interval
      }

      { name => options }
    end

    private

    def populate_facets(results)
      results['entries'].map { |entry|
        value = format_date(entry['time'])

        params        = create_result_params(value)
        add_params    = create_result_add_params(value)
        remove_params = create_result_remove_params(value)

        Result.new(value, entry['count'], params, add_params, remove_params, interval)
      }.reverse!
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
