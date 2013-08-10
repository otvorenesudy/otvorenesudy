module Probe
  class Configuration < Settingslogic
    source Rails.root.join('config', 'probe.yml')

    namespace Rails.env

    def self.models
      @models ||= indices.map { |e| e.constantize }
    end
  end
end
