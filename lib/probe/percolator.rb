# frozen_string_literal: true

module Probe
  # Stored searches of one model, in their own index (decrees_production_percolator) with the model's fields and a
  # percolator field holding each search's query and filters.
  class Percolator
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def index_name
      "#{model.index_name}_percolator"
    end

    def register(id, params)
      ensure_index

      facets = model.facets.extract_params(params.to_h.with_indifferent_access)
      query = { bool: { must: facets.queries.presence || [{ match_all: {} }], filter: facets.filters } }

      client.index(index: index_name, id:, body: { query: }, refresh: true)
    end

    def unregister(id)
      client.delete(index: index_name, id:, refresh: true)
    rescue Elastic::Transport::Transport::Errors::NotFound
      nil
    end

    def percolate(record)
      ensure_index

      body = { query: { percolate: { field: 'query', document: record.to_indexed_hash } }, _source: false,
               size: 10_000 }

      client.search(index: index_name, body:)['hits']['hits'].pluck('_id')
    end

    def delete_index
      client.indices.delete(index: index_name, ignore_unavailable: true)
    end

    private

    def client
      model.client
    end

    def ensure_index
      return if client.indices.exists?(index: index_name)

      mappings = model.mapping.to_h.deep_merge(properties: { query: { type: 'percolator' } })

      client.indices.create(index: index_name, body: { settings: Probe::Configuration.settings, mappings: })
    end
  end
end
