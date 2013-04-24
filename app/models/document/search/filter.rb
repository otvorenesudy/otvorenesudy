module Document
  module Search
    module Filter

      def build_filter(type, facets)
        filters = []

        facets.each do |_, facet|
          if facet.terms.any?
            filters << { or: facet.build_filter }
          end
        end

        filters
      end

    end
  end
end
