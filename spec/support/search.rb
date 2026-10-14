# frozen_string_literal: true

# Searches run on the real Elasticsearch (bin/elasticsearch), in the <index>_test indices. Records index themselves when
# saved; `refresh_indices` makes them searchable. The indices are emptied after every example.
module SearchHelpers
  def refresh_indices
    Probe.client.indices.refresh(index: SearchHelpers.indices, ignore_unavailable: true)
  end

  def self.indices
    Probe.models.flat_map { |model| [model.index_name, model.percolator.index_name] }.join(',')
  end
end

RSpec.configure do |config|
  config.include SearchHelpers

  config.before(:suite) do
    Probe.models.each do |model|
      model.delete_index
      model.percolator.delete_index
      model.ensure_index
    end
  end

  config.after do
    Probe.client.delete_by_query(
      index: SearchHelpers.indices,
      body: { query: { match_all: {} } },
      refresh: true,
      conflicts: 'proceed',
      ignore_unavailable: true
    )
  end
end
