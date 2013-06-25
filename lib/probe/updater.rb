module Probe
  class Updater
    def self.update(model)
      model.find_each do |record|
        record.update_index
      end
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
