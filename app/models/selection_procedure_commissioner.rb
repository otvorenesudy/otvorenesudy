class SelectionProcedureCommissioner < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed

  belongs_to :selection_procedure
  belongs_to :judge
end
