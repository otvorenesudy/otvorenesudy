module Probe
  class Bulk
    def self.import(model)
      model.delete_index
      model.create_index

      model.index.import(model, method: :bulk)

      model.index.refresh

      # model.alias_index_as(bulk_index) # TODO: use when percolating alias indices works in elasticsearch
    end

    def self.async_import(model)
      Resque.enqueue(AsyncImport, model.to_s)
    end

    def self.update(model)
      model.update_index
    end
  end

  class AsyncImport
    @queue = :probe

    def self.perform(model)
      Probe::Bulk.import(model.constantize)
    end
  end
end
