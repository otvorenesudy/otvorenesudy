module Probe
  class Record
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def index
      record.class.probe
    end

    def id
      record.id
    end

    def type
      index.type
    end

    def update
      index.store(self)
    end

    def percolate
      index.percolator.percolate(self)
    end

    def to_indexed_hash
      result = Hash.new

      index.mapping.each do |field, options|
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
