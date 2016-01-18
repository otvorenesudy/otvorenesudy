module Probe
  module Serialize
    def to_indexed_json
      result = {}

      self.class.mapping.each do |field, options|
        if options[:as]
          result[field] = options[:as].call(self)
        else
          result[field] = self.send(field)
        end
      end

      result
    end
  end
end
