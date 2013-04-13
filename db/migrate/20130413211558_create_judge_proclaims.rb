class CreateJudgeProclaims < ActiveRecord::Migration
  def change
    create_table :judge_proclaims do |t|
      t.references :judge_property_declaration, null: false
      t.references :judge_statement,            null: false

      t.timestamps
    end
    
    add_index :judge_property_declarations, [:judge_property_declaration_id, :judge_statement_id], unique: true
    add_index :judge_property_declarations, [:judge_statement_id, :judge_property_declaration_id], unique: true
  end
end
