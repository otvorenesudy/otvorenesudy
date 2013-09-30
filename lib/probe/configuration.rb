module Probe
  class Configuration
    include Squire::Base

    squire.source    Rails.root.join('config', 'probe.yml')
    squire.namespace Rails.env, base: :defaults

    def self.models
      @models ||= indices.map { |e| e.singularize.to_sym }
    end
  end
end
