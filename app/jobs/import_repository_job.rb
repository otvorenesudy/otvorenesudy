class ImportRepositoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :probe

  def perform(model, since = nil)
    relation = model.constantize.where('updated_at >= ?', since) if since
    client = Elasticsearch::Client.new
    repository = Repository.new(client)

    repository.bulk_import(relation)
  end
end
