class Document::Faceted::TermsFacet < Document::Faceted::Facet

  def build(facet, field)
    facet.terms field
  end

  private

  def format_facets(results)
    results['terms'].map do |term|
      format_term(term)
    end
  end

  def format_term(term)
    { value: term['term'], count: term['count'] }
  end

end
