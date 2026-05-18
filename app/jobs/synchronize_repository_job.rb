class SynchronizeRepositoryJob < ApplicationJob
  queue_as :probe

  def perform(model_name, options)
    options = options.symbolize_keys

    model = model_name.constantize
    range = (options[:from]..options[:to])
    relation = model.where(id: range)
    repository = RepositoryManager.new(model, relation: relation, client: Probe.client)

    repository.synchronize
  end

  def self.enqueue_for(model)
    model.select(:id).find_in_batches(batch_size: 10_000) do |batch|
      from = batch.first.id
      to = batch.last.id

      SynchronizeRepositoryJob.perform_later(model.to_s, from: from, to: to)
    end
  end
end
