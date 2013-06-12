module Probe
  class Config < Settingslogic
    source File.join(Rails.root, 'config', 'probe.yml')

    namespace Rails.env

    def self.models
      @models ||= indices.map { |e| e.singularize.to_sym }
    end
  end
end
