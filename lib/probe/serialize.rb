module Probe
  module Serialize
    def to_indexed_hash
      result = Hash.new

      self.class.probe.mapping.each do |field, options|
        if options[:as]
          result[field] = options[:as].call(self)
        else
          result[field] = self.send(field)
        end
      end

      result
    end

    def to_indexed_json
      to_indexed_hash.to_json
    end
  end
end
