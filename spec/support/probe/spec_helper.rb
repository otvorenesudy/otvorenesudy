module Probe
  module SpecHelper
    def self.reload_indices
      indices.each { |model| model.probe.reload }
    end

    def self.delete_indices
      indices.each { |model| model.probe.delete }
    end

    class << self
      alias :reload :reload_indices
      alias :delete :delete_indices
    end

    # for module includes
    def reload_indices
      Probe::SpecHelper.reload_indices
    end

    def delete_indices
      Probe::SpecHelper.delete_indices
    end

    private

    def self.indices
      Probe::Configuration.models
    end
  end
end
