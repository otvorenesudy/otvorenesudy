class CreateSelectionProcedureCandidates < ActiveRecord::Migration
  def change
    create_table :selection_procedure_candidates do |t|
      t.string :uri

      t.references :selection_procedure, null: false

      t.references :judge, null: true

      t.string :name,             null: false
      t.string :name_unprocessed, null: false

      t.text :accomplished_expectations

      t.string :oral_score
      t.string :oral_result

      t.string :written_score
      t.string :written_result

      t.string :score
      t.string :position

      t.timestamps
    end

    add_index :selection_procedure_candidates, :selection_procedure_id

    add_index :selection_procedure_candidates, :judge_id

    add_index :selection_procedure_candidates, :name
    add_index :selection_procedure_candidates, :name_unprocessed
  end
end
