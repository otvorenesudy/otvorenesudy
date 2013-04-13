class CreateJudgeProclaims < ActiveRecord::Migration
  def change
    create_table :judge_proclaims do |t|
      t.references :judge_property_declaration, null: false
      t.references :judge_statement,            null: false

      t.timestamps
    end
    
    add_index :judge_proclaims, [:judge_property_declaration_id, :judge_statement_id],
               unique: true, name: 'index_judge_proclaims_on_unique_values'
               
    add_index :judge_proclaims, [:judge_statement_id, :judge_property_declaration_id],
               unique: true, name: 'index_judge_proclaims_on_unique_values_reversed'
  end
end
