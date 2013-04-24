class Document::Facets::DateFacet < Document::Facets::Facet
  attr_accessor :interval

  def initialize(name, field, options)
    super(name, field, options)

    @interval = options[:interval]
    @alias  ||= method(:alias_date)
  end

  def build(facet, field)
    facet.date field, interval: @interval
  end

  def build_filter
    terms.map do |value|
      { range: { not_analyzed_field(@field) => { gte: value.min, lte: value.max } } }
    end
  end

  private

  def format_facets(results)
    results['entries'].map do |e|
      format_entry(e)
    end.reverse!
  end

  def format_entry(entry)
    { value: format_value(entry['time']),  count: entry['count'] }
  end

  def format_time(timestamp)
    Time.at(timestamp.to_i/1000)
  end

  def format_value(value)
    # TODO: more interval options
    # TODO: resolve multiple time format (es=Date, others=Timestamp)

    if value.is_a?(Range)
      date = value.first
    else
      date = format_time(value)
    end

    case @interval
    when :month
      date.beginning_of_month.to_i..date.end_of_month.to_i
    end
  end

  def alias_date(range)
    # TODO: use sk.yml for format? such as :month and so on, according to @interval?

    time = Time.at(range.first)

    format = case @interval
             when :month then '%B, %Y'
             end

    I18n.l time, format: format
  end

end
