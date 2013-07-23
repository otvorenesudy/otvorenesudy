module Probe
  module Helpers
    module Index
      def wrap_field(field)
        return :* if field.eql? :all

        return field.map { |f| f.to_sym } if field.is_a? Array

        return field
      end

      def analyzed_field(field)
        field = wrap_field(field)

        return field.map { |f| "#{f}.analyzed".to_sym } if field.is_a? Array

        "#{field}.analyzed".to_sym
      end

      def not_analyzed_field(field)
        field = wrap_field(field)

        return field.map { |f| "#{field}.untouched".to_sym } if field.is_a? Array

        "#{field}.untouched".to_sym
      end

      def has_field?(field)
        @mappings ? @mappings[field].present? : false
      end

      def has_sort_field?(field)
       @sort_fields ? @sort_fields.include?(field) : false
      end

      def has_facet?(name)
        @facets ? @facets[name].present? : false
      end

      def create_facet(type, name, field, options)
        "Probe::Facets::#{type.to_s.camelcase}Facet".constantize.new(name,field, options)
      end
    end
  end
end
