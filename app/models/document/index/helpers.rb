module Document
  module Index
    module Helpers
      def analyzed_field(field)
        return field.map { |f| "#{f}.analyzed".to_sym } if field.is_a? Array

        "#{field}.analyzed".to_sym
      end

      def not_analyzed_field(field)
        return field.map { |f| "#{field}.untouched".to_sym } if field.is_a? Array

        "#{field}.untouched".to_sym
      end

      def selected_facet_name(name)
        "#{name}_selected".to_sym
      end

      def selected_facet_name?(name)
        name.to_s =~ /_selected/
      end

      def suggested_facet_name(name)
        "#{name}_suggest"
      end

      def missing_facet_name
        "missing"
      end

      def has_field?(field)
        @mappings ? @mappings[field].present? : false
      end

      def has_facet?(name)
        @facets ? @facets[name].present? : false
      end

      def create_facet(type, name, field, options)
        # TODO: core/injector
        "Document::Facets::#{type.to_s.camelcase}Facet".constantize.new(name,field, options)
      end
    end
  end
end
