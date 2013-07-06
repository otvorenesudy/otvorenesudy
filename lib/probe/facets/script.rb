class Probe::Facets
  class Script
    include Probe::Sanitizer

    def initialize(options)
      @name   = options[:name]
      @script = options[:script]
      @params = options[:params] || Hash.new
    end

    def add_script_params(params)
      @params.deep_merge! params
    end

    def build
      { script: build_script, params: build_params }
    end

    private

    def build_params
      @params
    end

    def build_script
      @script
    end
  end
end
