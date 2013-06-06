module Document::Facets
  class TermsFacet < Document::Facets::Facet
    def build(facet)
      facet.terms not_analyzed_field(@field), size: @size
    end

    def build_filter
      terms.map do |value|
        if value == missing_facet_name
          { missing: { field: not_analyzed_field(@field) }}
        else
          { term: { not_analyzed_field(@field) => value } }
        end
      end
    end

    private

    def format_facets(results)
      values = results['terms'].map do |term|
        format_term(term['term'], term['count'])
      end

      missing_count = results['missing']

      values << format_term(missing_facet_name, missing_count) if missing_count > 0

      values
    end

    def format_term(value, count)
      { value: value, count: count }
    end
  end
end
