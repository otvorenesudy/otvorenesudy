class Document::Faceted::Facet
  attr_accessor :name,
                :selected,
                :type,
                :alias,
                :values

  def initialize(name, options)
    @name     = name
    @type     = options[:type]
    @alias    = options[:as]
  end

  def populate(results)
    results = yield results if block_given?

    results = format_facets(results)

    results.concat format_facets(selected) if selected

    @values = results.map(&:symbolize_keys)
  end

  def values
    @values.map! do |data|
      data = yield data if block_given?

      if @alias
        data[:alias] = @alias.call data[:value]
      else
        data[:alias] = data[:value]
      end

      data[:value] = data[:value].to_s

      data.slice(:value, :count, :alias)
    end

    @values
  end

  private

  def format_value(value)
    value
  end

end
