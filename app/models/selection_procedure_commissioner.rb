# frozen_string_literal: true

class SelectionProcedureCommissioner < ApplicationRecord
  belongs_to :procedure, class_name: 'SelectionProcedure',
                         foreign_key: :selection_procedure_id,
                         inverse_of: false,
                         optional: true

  belongs_to :judge, optional: true
end
