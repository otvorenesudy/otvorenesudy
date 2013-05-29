module Document
  module Serializable
    def to_indexed_json
      result = {}

      self.class.mapping.each do |field, value|
        options = value[:options]

        if options[:as]
          result[field] = options[:as].call(self)
        elsif value[:block]
          map       = []
          relations = self.send(field)

          relations.each do |relation|
            fields = {}

            options[:fields].each do |f|
              fields[f] = relation.send(f)
            end

            map << fields
          end

          result[field] = map
        else
          result[field] = self.send(field)
        end
      end

      result.to_json
    end
  end
end
