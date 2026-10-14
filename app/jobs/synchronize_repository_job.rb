# frozen_string_literal: true

# Reindexes the records of one id range whose document is missing or older than the record.
class SynchronizeRepositoryJob < ApplicationJob
  queue_as :probe

  BATCH_SIZE = 10_000

  def self.enqueue_for(model)
    model.in_batches(of: BATCH_SIZE) do |batch|
      ids = batch.ids

      perform_later(model.name, ids.min, ids.max)
    end
  end

  def perform(model_name, from, to)
    model = Probe.models.find { |candidate| candidate.name == model_name }

    raise ArgumentError, "#{model_name} isn't searchable" unless model

    RepositoryManager.new(model, relation: model.where(id: from..to)).synchronize
  end
end
