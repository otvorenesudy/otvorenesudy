module Judge::SubstantiationNotes
  def substantiation_notes
    @substantiation_notes ||= statistical_summaries.pluck(:substantiation_notes).uniq
  end
end
