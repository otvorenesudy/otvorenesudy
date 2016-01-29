class SynchronizeRepositoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :probe

  def perform(model_name, options)
    options.symbolize_keys!

    model = model_name.constantize
    range = (options[:from]..options[:to])
    relation = model.where(id: range)
    repository = RepositoryManager.new(model, relation: relation, client: Elasticsearch::Client.new)

    repository.synchronize
  end

  def self.enqueue_for(model)
    model.select(:id).find_in_batches(batch_size: 10_000) do |batch|
      from = batch.first.id
      to = batch.last.id

      SynchronizeRepositoryJob.perform_async(model.to_s, from: from, to: to)
    end
  end
end
