module Probe::Search
  class Percolator
    def initialize(model, options)
      @model   = model
      @options = options
    end

    def register(id, params)
      @options.merge! params: params

      composer = Probe::Search::Composer.new(@model, @options)

      @model.index.register_percolator_query(id) do |query|
        composer.compose_filtered_query(query)
      end

      refresh_precolator
    end

    def unregister(id)
      @model.index.unregister_percolator_query(id)

      refresh_precolator
    end

    def percolate(document)
      @model.index.percolate(document)
    end

    private

    def refresh_precolator
      Tire.index('_percolator').refresh
    end
  end
end
