module Document
  module Search
    module Facet
      def build_facet(index, name, field, facet, options)
        index.facet name, options do |f|
          facet.build(f)
        end
      end
    end
  end
end
