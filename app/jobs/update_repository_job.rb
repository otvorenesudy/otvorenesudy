require 'elasticsearch'

class UpdateRepositoryJob
  include Sidekiq::Worker

  def perform(model, since)
    relation = model.constantize.where('updated_at >= ?', since)
    client = Elasticsearch::Client.new
    repository = Repository.new(client)

    repository.bulk_import(relation)
  end
end
