# frozen_string_literal: true

class SelectionProcedureCandidate < ApplicationRecord
  include Resource::Storage

  belongs_to :procedure, class_name: 'SelectionProcedure', foreign_key: :selection_procedure_id, optional: true,
                         inverse_of: :candidates
  belongs_to :judge, optional: true

  %w[application curriculum declaration motivation_letter].each do |document|
    storage(document, 'documents/selection_procedure_candidates') { |candidate| "#{candidate.ic}_#{document}.pdf" }
  end

  # The candidate's id on justice.gov.sk.
  def ic
    uri[/Ic=(\d+)/, 1]
  end
end
