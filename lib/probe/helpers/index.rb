module Probe
  module Helpers
    module Index
      def analyzed_field(field)
        return field.map { |f| f.to_sym } if field.is_a?(Array)
        field.to_sym
      end

      def not_analyzed_field(field)
        return field.map { |f| :"#{f}.raw" } if field.is_a?(Array)
        :"#{field}.raw"
      end

      def has_field?(field)
        @mapping ? @mapping[field].present? : false
      end

      def has_sort_field?(field)
        @sort_fields ? @sort_fields.include?(field) : false
      end

      def has_facet?(name)
        @facets ? @facets[name].present? : false
      end

      def create_facet(type, name, field, options)
        "Probe::Facets::#{type.to_s.camelize}Facet".constantize.new(name, field, options)
      end
    end
  end
end
