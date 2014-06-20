class SelectionProcedureCommissioner < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed

  belongs_to :procedure, class_name: :SelectionProcedure, foreign_key: :selection_procedure_id
  belongs_to :judge
end
