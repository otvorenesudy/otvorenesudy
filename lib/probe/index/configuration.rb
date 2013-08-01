class Probe::Index
  module Configuration
    def name
      @name ||= "#{type.to_s.pluralize}_#{Rails.env}"
    end

    def configuration
      Probe::Configuration
    end

    def settings(params = {})
      settings = configuration.index

      settings.deep_merge! params

      settings
    end

    def setup
      if base < ActiveRecord::Base
        base.after_save    { probe.update }
        base.after_destroy { probe.update }
      end
    end
  end
end
