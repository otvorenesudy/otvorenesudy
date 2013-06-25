module Probe
  module Helpers
    module Index
      def analyzed_field(field)
        return field.map { |f| "#{f}.analyzed".to_sym } if field.is_a? Array

        "#{field}.analyzed".to_sym
      end

      def not_analyzed_field(field)
        return field.map { |f| "#{field}.untouched".to_sym } if field.is_a? Array

        "#{field}.untouched".to_sym
      end

      def suggested_field(field)
        return field.map { |f| "#{f}.suggested".to_sym } if field.is_a? Array

        "#{field}.suggested".to_sym
      end

      def format_suggested_field(values)
        values = Array.wrap(values)

        values.map do |value|
          value = value.to_s

          "#{value}#{Probe::Configuration.suggest.matcher.params.separator}#{value.ascii.downcase}"
        end
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
        # TODO: core/injector, rm TODO, should not depend on core
        "Probe::Facets::#{type.to_s.camelcase}Facet".constantize.new(name,field, options)
      end
    end
  end
end
