module Probe
  module SpecHelper
    def self.reload_indices
      indices.each(&:reload_index)

      sleep 1
    end

    def self.delete_indices
      indices.each(&:delete_index)

      sleep 1
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
      Probe::Configuration.indices.map do |index|
        index.to_s.singularize.camelcase.constantize
      end
    end
  end
end
