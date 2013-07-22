class Probe::Facets
  class Script
    include Probe::Sanitizer

    def initialize(options)
      @name   = options[:name]
      @script = options[:script]
      @params = options[:params] || Hash.new
      @lang   = options[:lang]
    end

    def add_script_params(params)
      @params.deep_merge! params
    end

    def build
      { script: build_script, params: build_params, lang: @lang }
    end

    private

    def build_params
      @params
    end

    def build_script
      @script || @name
    end
  end
end
