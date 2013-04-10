class Document::Faceted::Facet
  attr_accessor :name,
                :type,
                :alias,
                :values

  def initialize(name, options)
    @name  = name
    @type  = options[:type]
    @alias = options[:as]
  end

  def populate(results)
    results = yield results if block_given?

    @values = results.map(&:symbolize_keys)
  end

  def values
    @values.map! do |data|
      data = yield data if block_given?

      data[:alias] = @alias.call data if @alias # TODO: consider passing only data[:value]

      data.slice(:value, :count, :alias)
    end

    @values
  end

end
