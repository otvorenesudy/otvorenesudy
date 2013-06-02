module Document
  module Search
    module Filter
      def build_filter_from(type, facets)
        filters = []

        facets.each do |_, facet|
          filters << { type => facet.build_filter } if facet.terms.present?
        end

        filters
      end
    end
  end
end
