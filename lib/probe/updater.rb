module Probe
  class Updater
    def self.update(model)
      model.delete_index
      model.create_index

      model.index.import(model, method: :bulk)
      model.index.refresh

      #model.alias_index_as(bulk_index) # TODO: use when percolating alias indices works in elasticsearch
    end

    def self.async_update(model)
      Resque.enqueue(AsyncUpdater, model.to_s)
    end
  end

  class AsyncUpdater
    @queue = :probe_update

    def self.perform(model)
      Probe::Updater.update(model.constantize)
    end
  end
end
