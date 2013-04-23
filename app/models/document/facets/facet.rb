class Document::Facets::Facet
  attr_accessor :name,
                :selected,
                :terms,
                :type,
                :alias,
                :values,
                :size

  def initialize(name, field, options)
    @name     = name
    @field    = field
    @type     = options[:type]
    @alias    = options[:as]
    @size     = options[:size] || 10
    @selected = Array.new
  end

  def terms
    @terms ||= []
  end

  def refresh!
    @selected = []
    @terms    = []
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
