module Document
  module Search
    module Facet
      def build_facet(index, name, field, facet, options)
        index.facet name, options do |f|
          facet.build(f, not_analyzed_field(field))
        end
      end

      def facet_filter(query, facets)
        filter = build_facet_filter(query, facets) if query.any? || facets.any?

        { and: filter } if filter.any?
      end

      def build_facet_filter(query, facets)
        build_query(query).concat(build_filter(:or, facets))
      end
    end
  end
end
