module Document
  module Search
    module Facet

      def build_facet(index, name, field, facet, options)
        index.facet name, options do |f|

          facet.build(f, not_analyzed_field(field))

        end
      end

      def facet_filter(query, terms)
        filter = Hash.new

        filter[:and] = build_facet_filter(query, terms) if query.any? or terms.any?

        filter
      end

      def build_facet_filter(query, terms)
        filter_values = []

        filter_values.concat build_query(query)
        filter_values.concat build_filters(terms)

        filter_values
      end

    end
  end
end
