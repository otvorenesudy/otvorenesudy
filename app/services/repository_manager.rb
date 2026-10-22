# frozen_string_literal: true

# Compares records with their documents and reindexes those whose document is missing or older. SynchronizeRepositoryJob
# runs it on id ranges of up to 10,000 records.
class RepositoryManager
  attr_reader :model, :relation

  def initialize(model, relation:)
    @model = model
    @relation = relation
  end

  def synchronize
    model.ensure_index

    records = relation.to_a
    documents = fetch_documents(records.map(&:id))
    stale = records.reject { |record| current?(record, documents[record.id]) }

    model.bulk_index(model.index_name, stale) if stale.any?
  end

  private

  def fetch_documents(ids)
    return {} if ids.empty?

    response = model.client.mget(index: model.index_name, body: { ids: }, _source_includes: ['updated_at'])

    response['docs'].select { |doc| doc['found'] }.index_by { |doc| doc['_id'].to_i }
  end

  # Documents keep updated_at to the millisecond.
  def current?(record, document)
    return false unless document

    indexed = Time.zone.parse(document.dig('_source', 'updated_at').to_s)

    indexed.present? && indexed.floor(3) == record.updated_at.floor(3)
  end
end
