class SynchronizeRepositoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :probe

  def perform(model_name)
    model = model_name.constantize
    repository = RepositoryManager.new(model, client: Elasticsearch::Client.new)

    repository.synchronize
  end
end
