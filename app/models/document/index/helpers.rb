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

      def selected_field(field)
        "#{field}_selected".to_sym
      end

      def selected_field?(field)
        field.to_s =~ /_selected/
      end

      def has_field?(field)
        @mappings ? @mappings[field].present? : false
      end

      def has_facet?(name)
        @facets ? @facets[name].present? : false
      end
    end
  end
end
