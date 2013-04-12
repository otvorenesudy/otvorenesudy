class Document::Faceted::DateFacet < Document::Faceted::Facet
  attr_accessor :interval

  def initialize(name, options)
    super(name, options)

    @interval = options[:interval]
    @alias  ||= method(:alias_date)
  end

  def populate(results)
    super(results) do |res|

      res['entries'].map do |e|
        {
          time:  format_time(e['time']), # for alias
          value: format_date_range(e['time']).to_s,
          count: e['count']
        }
      end.reverse!

    end
  end

  private

  def format_time(timestamp)
    Time.at(timestamp.to_i/1000)
  end

  def format_date_range(timestamp)
    # TODO: more interval options

    date = format_time(timestamp)

    case @interval
    when :month
      date.beginning_of_month.to_i..date.end_of_month.to_i
    end
  end

  def alias_date(data)
    # TODO: use sk.yml for format? such as :month and so on, according to @interval?

    format = case @interval
             when :month then '%B, %Y'
             end

    I18n.l data[:time], format: format
  end

end
