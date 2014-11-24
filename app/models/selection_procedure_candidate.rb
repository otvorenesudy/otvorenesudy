class SelectionProcedureCandidate < ActiveRecord::Base
  attr_accessible :application_url,
                  :curriculum_url,
                  :declaration_url,
                  :motivation_letter_url,
                  :name,
                  :name_unprocessed,
                  :accomplished_expectations,
                  :oral_score,
                  :oral_result,
                  :written_score,
                  :written_result,
                  :score,
                  :rank

  belongs_to :procedure, class_name: :SelectionProcedure, foreign_key: :selection_procedure_id
  belongs_to :judge
end
