module Probe
  module Serialize
    module Record
      def to_indexed_hash
        result = Hash.new

        mapper.mapping.each do |field, options|
          if options[:as]
            result[field] = options[:as].call(record)
          else
            result[field] = record.send(field)
          end
        end

        result
      end

      def to_indexed_json
        to_indexed_hash.to_json
      end
    end
  end
end
