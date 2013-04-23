module Document
  module Search
    module Filter

      def build_filter(type, facets)
        filters = []

        facets.each do |field, facet|
          if facet.terms.any?
            field = not_analyzed_field(field)

            filters << { or: facet.build_filter }
          end
        end

        filters
      end

    end
  end
end
