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
      AsyncImport.perform_async(model.to_s)
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

    def perform(model)
      Probe::Bulk.import(model.constantize)
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
