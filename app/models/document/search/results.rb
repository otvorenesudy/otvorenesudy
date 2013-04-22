module Document
  module Search
    module Results

      def fetch_records(hits)
        return [] unless hits

        hits.map do |hit|
          self.find(hit.id)
        end
      end

      def format_facets(results)
        facets = Hash.new

        return facets unless results

        results.symbolize_keys!

        facet_results = results.select { |field, _| !selected_field?(field) }

        facet_results.each do |field, values|
          facet  = @facets[field]

          facet.selected = results[selected_field(field)]

          facet.populate(values)

          facets[field] = facet.values
        end

        facets
      end

      def format_result(result)
        data = Hash.new

        data[:results]    = fetch_records(result.results)
        data[:facets]     = format_facets(result.facets)
        data[:highlights] = result.results.map do |res|
          highlights = Hash.new

          @highlights.each do |field|
            highlights[field] = res.highlight[analyzed_field(field)] if res.highlight
          end

          highlights
        end

        return data, result
      end

    end
  end
end
