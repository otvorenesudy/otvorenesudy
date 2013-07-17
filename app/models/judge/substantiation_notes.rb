module Judge::SubstantiationNotes
  extend ActiveSupport::Concern
  
  def substantiation_notes
    @substantiation_notes ||= statistical_summaries.order('year desc').map do |summary|
      [summary.year, summary.substantiation_notes]
    end
  end
end
