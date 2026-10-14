# frozen_string_literal: true

module Probe
  # The fields a model indexes, declared in its `mapping` block, and the Elasticsearch mapping they make.
  #
  #   map :id                                    indexed as is (keyword)
  #   analyze :name                              as is, as full text and folded (see Probe::Fields)
  #   analyze :count, type: :integer, as: ->(r)  the value comes from the lambda instead of the attribute
  #   analyze :text, index: :no                  full text only; the value is too long to filter or sort by
  class Mapping
    Field = Data.define(:name, :analyzed, :options) do
      def value_for(record)
        options[:as] ? options[:as].call(record) : record.public_send(name)
      end
    end

    TYPES = {
      string: 'keyword',
      integer: 'integer',
      float: 'float',
      date: 'date',
      boolean: 'boolean'
    }.freeze

    # Longer values are kept in _source but not indexed: Lucene can't index a term over 32,766 bytes.
    KEYWORD_LIMIT = 8191

    attr_reader :fields, :sort_fields

    def initialize
      @fields = {}
      @sort_fields = []
    end

    def map(name, **options)
      @fields[name.to_sym] = Field.new(name.to_sym, false, options)
    end

    def analyze(name, **options)
      @fields[name.to_sym] = Field.new(name.to_sym, true, options)
    end

    def sort_by(*fields)
      @sort_fields = fields.map(&:to_sym)
    end

    def to_h
      { dynamic: 'strict', properties: fields.values.to_h { |field| [field.name, property(field)] } }
    end

    # Text sorts regardless of case and diacritics (Čierny between Cibuľa and Dobos), by its folded subfield.
    def sort_field(name)
      field = fields.fetch(name.to_sym)
      folded = field.analyzed && field.options.fetch(:type, :string) == :string && field.options[:index] != :no

      folded ? Probe::Fields.folded(name) : Probe::Fields.keyword(name)
    end

    private

    def property(field)
      type = TYPES.fetch(field.options.fetch(:type, :string))
      property = { type: }

      property[:ignore_above] = KEYWORD_LIMIT if type == 'keyword'

      return property unless field.analyzed

      if field.options[:index] == :no
        property[:index] = false
        property[:doc_values] = false
      end

      property.merge(fields: subfields(field, type))
    end

    def subfields(field, type)
      analyzer = field.options.fetch(:analyzer, :text_analyzer)
      subfields = { analyzed: { type: 'text', analyzer: } }

      if type == 'keyword' && field.options[:index] != :no
        subfields[:folded] = { type: 'keyword', normalizer: 'folding', ignore_above: KEYWORD_LIMIT }
      end

      subfields
    end
  end
end
