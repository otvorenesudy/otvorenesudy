class ImportRepositoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :probe

  def perform(model_name, since = nil)
    relation = model_name.constantize
    relation = relation.where('updated_at >= ?', since) if since
    client = Elasticsearch::Client.new
    repository = Repository.new(client)

    repository.bulk_import(relation)
  end
end
