module Judge::ConstitutionalDecrees
  extend ActiveSupport::Concern
  
  def released_constitutional_decrees_total
    @released_constitutional_decrees_total ||= statistical_summaries.sum :released_constitutional_decrees
  end

  def delayed_constitutional_decrees_total
    @delayed_constitutional_decrees_total ||= statistical_summaries.sum :delayed_constitutional_decrees
  end
end
