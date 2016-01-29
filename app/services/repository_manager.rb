class RepositoryManager
  attr_accessor :model, :relation, :client

  def initialize(model, relation:, client:)
    @model = model
    @relation = relation
    @client = client
  end

  def synchronize
    batch = relation.to_a

    results = client.search(
      index: model.index_name,
      type: model.document_type,
      body: {
        filter: {
          or: batch.map { |record|
            {
              and: [
                { term: { id: record.id } },
                { term: { :'updated_at.untouched' => record.updated_at } }
              ]
            }
          },
        },
        size: batch.size,
        fields: [:id]
      }
    )

    synchronized = results['hits']['hits'].map { |e| e['fields']['id'][0].to_i }
    unsynchronized = batch.select { |record| !record.id.in?(synchronized) }

    unsynchronized.each(&:update_index)
  end
end
