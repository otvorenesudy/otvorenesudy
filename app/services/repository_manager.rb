class RepositoryManager
  attr_accessor :model, :relation, :client

  def initialize(model, relation:, client:)
    @model = model
    @relation = relation
    @client = client
  end

  def synchronize
    batch = relation.select('id, updated_at')

    results = client.search(
      index: model.index_name,
      type: model.document_type,
      body: {
        filter: {
          not: {
            or: relation.map { |record|
              {
                and: [
                  { term: { id: record.id } },
                  { term: { :'updated_at.untouched' => record.updated_at } }
                ]
              }
            },
          }
        },
        size: batch.size,
        fields: [:id]
      }
    )

    unsynchronized = results['hits']['hits'].map { |e| e['fields']['id'][0].to_i }

    model.where(id: unsynchronized).find_each(&:update_index)
  end
end
