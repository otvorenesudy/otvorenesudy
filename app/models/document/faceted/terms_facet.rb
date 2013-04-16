class Document::Faceted::TermsFacet < Document::Faceted::Facet

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
