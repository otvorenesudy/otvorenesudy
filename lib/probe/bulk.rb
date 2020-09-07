module Probe
  class Bulk
    def self.import(model)
      model.delete_index
      model.create_index

      model.index.import(model, method: :bulk, per_page: 5000)

      model.index.refresh

      # model.alias_index_as(bulk_index) # TODO: use when percolating alias indices works in elasticsearch
    end

    def self.async_import(model)
      model.delete_index
      model.create_index

      model.order(id: :asc).find_in_batches(batch_size: 5000) do |batch|
        AsyncImport.perform_async(model.to_s, batch[0].id, batch[-1].id)
      end

      model.index.refresh
    end

    def self.update(model)
      model.update_index
    end

    def self.async_update(model)
      AsyncUpdate.perform_async(model.to_s)
    end
  end

  class AsyncImport
    include Sidekiq::Worker

    sidekiq_options queue: :probe

    def perform(model, from, to)
      model = model.constantize
      model.index.import(model.where('id >= ? AND id <= ?', from, to), method: :bulk)
    end
  end

  class AsyncUpdate
    include Sidekiq::Worker

    sidekiq_options queue: :probe

    def perform(model)
      Probe::Bulk.update(model.constantize)
    end
  end
end
