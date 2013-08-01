class Probe::Index
  module Mapping
    def mapping(options = {}, &block)
      return @mapping ||= Hash.new unless block_given?

      @mapping_definitions = Hash.new

      mapping_options.merge! options

      update_mapping(&block)

      block.arity > 0 ? block.call(self) : instance_eval(&block)

      @mapping_definitions.each do |field, value|
        options  = value[:options] || Hash.new

        type     = options[:type]     || :string
        analyzer = options[:analyzer] || Probe::Configuration.default_analyzer
        as       = options.delete(:as)

        case value[:type]
        when :map
          mapping.merge! field => options.merge(type: type, index: :not_analyzed, as: as)
        when :analyze
          mapping.merge! field => {
            type: :multi_field,
            fields: {
              field =>  options.merge!(type: :string, analyzer: analyzer),
              untouched: { type: type, index: :not_analyzed }
            },
            as: as
          }
        end
      end
    end

    def update_mapping(&block)
      if block_given?
        @mapping_block = block
      else
        mapping(&@mapping_block)

        index.put_mapping(*mapping_to_hash.first)
      end
    end

    def mapping_options
      @mapping_options ||= Hash.new
    end

    def mapping_to_hash
      { type.to_sym => mapping_options.merge({ properties: mapping }) }
    end

    private

    def map(field, options = {})
      @mapping_definitions[field] = Hash.new

      @mapping_definitions[field].merge! type: :map, options: options
    end

    def analyze(field, options = {})
      @mapping_definitions[field] = Hash.new

      @mapping_definitions[field].merge! type: :analyze, options: options
    end
  end
end
