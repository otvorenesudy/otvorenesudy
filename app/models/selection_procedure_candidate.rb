class SelectionProcedureCandidate < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed,
                  :accomplished_expectations,
                  :oral_score,
                  :oral_result,
                  :written_score,
                  :written_result,
                  :score,
                  :position

  belongs_to :procedure, class_name: :SelectionProcedure, foreign_key: :selection_procedure_id
  belongs_to :judge
end
