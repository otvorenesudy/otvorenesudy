class AddDocumentUrlsToSelectionProcedures < ActiveRecord::Migration
  def change
    add_column :selection_procedures, :declaration_url, :string, null: true
    add_column :selection_procedures, :report_url,      :string, null: true
  end
end
