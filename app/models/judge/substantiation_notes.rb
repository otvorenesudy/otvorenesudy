module Judge::SubstantiationNotes
  extend ActiveSupport::Concern
  
  def substantiation_notes
    @substantiation_notes ||= statistical_summaries.order('year desc').map { |summary|
      [summary.year, summary.substantiation_notes] unless summary.substantiation_notes.blank? 
    }.reject(&:nil?)
  end
end
