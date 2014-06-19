class SelectionProcedureCandidate < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed,
                  :accomplised_expectations,
                  :oral_score,
                  :oral_result,
                  :written_score,
                  :written_result

  belongs_to :selection_procedure
  belongs_to :judge
end
