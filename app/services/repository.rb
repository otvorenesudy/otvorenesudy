class Repository < Struct.new(:client)
  def bulk_import(relation)
    relation.order(:id).find_in_batches(batch_size: 10000) do |batch|
      body = batch.map do |document|
        {
          index: {
            _index: relation.index_name,
            _type: relation.document_type,
            _id: document.id,
            data: document.to_indexed_json
          }
        }
      end

      client.bulk(body: body)
    end
  end
end
