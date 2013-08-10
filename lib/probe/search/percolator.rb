module Probe::Search
  # TODO: wait for elasticsearch to use aliases when percolating

  class Percolator
    attr_reader :probe

    def initialize(probe)
      @probe = probe
    end

    def register(id, params)
      composer = Probe::Search::Composer.new(@probe, params)

      probe.index.register_percolator_query(id, composer.compose_filtered_query)

      refresh_precolator
    end

    def unregister(id)
      probe.index.unregister_percolator_query(id)

      refresh_precolator
    end

    def percolate(document)
      probe.index.percolate(document)
    end

    private

    def refresh_precolator
      probe.index('_percolator').refresh
    end
  end
end
