class RepositoryManager
  attr_accessor :model, :client

  def initialize(model, client:)
    @model = model
    @client = client
  end

  def synchronize
    model.select('id, updated_at').find_in_batches(batch_size: 10000) do |batch|
      results = client.search(
        index: model.index_name,
        type: model.document_type,
        body: {
          filter: {
            not: {
              or: batch.map { |record|
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
end
