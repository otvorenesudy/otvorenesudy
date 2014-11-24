class AddDocumentUrlsToSelectionProcedureCandidates < ActiveRecord::Migration
  def change
    add_column :selection_procedure_candidates, :application_url,       :string, null: true
    add_column :selection_procedure_candidates, :curriculum_url,        :string, null: true
    add_column :selection_procedure_candidates, :declaration_url,       :string, null: true
    add_column :selection_procedure_candidates, :motivation_letter_url, :string, null: true
  end
end
