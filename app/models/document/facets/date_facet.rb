module Document::Facets
  class DateFacet < Document::Facets::RangeFacet
    attr_accessor :interval

    def initialize(name, field, options)
      options[:converter] = Document::Converters::Date

      super(name, field, options)

      @interval = options[:interval]
    end

    def build(facet, field)
      facet.date field, interval: @interval
    end

    private

    def format_facets(results)
      results['entries'].map do |e|
        format_entry(e)
      end.reverse!
    end

    def format_entry(entry)
      { value: format_value(entry['time']), count: entry['count'] }
    end

    def format_value(value)
      # TODO: more interval options
      # TODO: resolve multiple time format (es=Date, others=Timestamp)

      date = @converter.from_elastic(value)

      case @interval
      when :month
        date.beginning_of_month.to_i..date.end_of_month.to_i
      end
    end

    def alias_range(range)
      # TODO: use sk.yml for format? such as :month and so on, according to @interval?

      time = Time.at(range.first)

      format = case @interval
              when :month then '%B, %Y'
              end

      I18n.l time, format: format
    end
  end

end
