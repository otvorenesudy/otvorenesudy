class RenameSelectionProcedureCandidatePositionToRank < ActiveRecord::Migration
  def change
    rename_column :selection_procedure_candidates, :position, :rank
  end
end
