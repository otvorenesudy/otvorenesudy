class CreateSelectionProcedureCommissioners < ActiveRecord::Migration
  def change
    create_table :selection_procedure_commissioners do |t|
      t.references :selection_procedure, null: false

      t.references :judge, null: true

      t.string :name,             null: false
      t.string :name_unprocessed, null: false

      t.timestamps
    end

    add_index :selection_procedure_commissioners, :selection_procedure_id,
               name: :index_commissioners_on_selection_procedure

    add_index :selection_procedure_commissioners, :judge_id

    add_index :selection_procedure_commissioners, :name
    add_index :selection_procedure_commissioners, :name_unprocessed
  end
end
