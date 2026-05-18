module Probe
  class Configuration
    def self.config
      @config ||= Rails.application.config_for(:probe).with_indifferent_access
    end

    def self.method_missing(name, *args)
      config[name]
    end

    def self.respond_to_missing?(name, include_private = false)
      config.key?(name) || super
    end

    def self.models
      @models ||= Array(config[:indices]).map { |e| e.to_s.singularize.to_sym }
    end

    def self.per_page
      config[:per_page] || 20
    end

    def self.index
      config[:index] || {}
    end
  end
end
