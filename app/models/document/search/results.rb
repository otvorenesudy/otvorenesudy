module Document
  module Search
    module Results

      def fetch_records(hits)
        return [] unless hits

        hits.map do |hit|
          self.find(hit.id)
        end
      end

      def format_facets(defined_facets, results)
        facets = Hash.new

        return facets unless results

        results.symbolize_keys!

        facet_results = results.select { |field, _| !selected_facet_name?(field) }

        facet_results.each do |name, values|
          facet = defined_facets[name]

          facet.selected = results[selected_facet_name(name)]

          facet.populate(values)

          facets[name] = facet.values
        end

        facets
      end

      def format_highlights(facets, results)
        highlights = []

        facets = facets.select { |_, f| f.highlighted? }

        results.each do |result|
          highlight = Hash.new

          facets.each do |_, facet|
            field = facet.field

            if field.respond_to? :each
              field.each do |f|
                analyzed_field = analyzed_field(f)

                highlight[f] = result.highlight[analyzed_field] if result.highlight
              end
            else

              highlight[field] = result.highlight[analyzed_field] if result.highlight
            end
          end

          highlights << highlight
        end

        highlights
      end

      def format_result(facets, result)
        data               = Hash.new

        data[:results]    = fetch_records(result.results)
        data[:facets]     = format_facets(facets, result.facets)
        data[:highlights] = format_highlights(facets, result.results)

        return data, result
      end

    end
  end
end
