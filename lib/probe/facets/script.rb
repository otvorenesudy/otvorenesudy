class Probe::Facets
  class Script
    def initialize(options)
      @name   = options[:name]
      @script = options[:script]
      @params = options[:params] || Hash.new
    end

    def add_script_params(params)
      @params.deep_merge! params
    end

    def add_match_param(name, value)
      # TODO: create sanitize method
      add_script_params(name => value.gsub(/["']/, "").ascii.downcase.split(/[[:space:]]/))
    end

    def build
      build_params + build_script
    end

    private

    def build_params
      "params = #{@params.to_json};"
    end

    def build_script
      @script
    end
  end
end
