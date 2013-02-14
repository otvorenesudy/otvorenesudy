class Document::Digest::TermsFacet < Document::Digest::Facet

  def populate(results)
    super(results) do |res|
      
      res['terms'].map do |e|
        { value: e['term'], count: e['count'] }
      end

    end
  end

end
