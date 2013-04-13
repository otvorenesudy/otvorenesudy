class CreateJudgePropertyDeclarations < ActiveRecord::Migration
  def change
    create_table :judge_property_declarations do |t|
      t.references :judge, null: false
      
      t.integer :year, null: false 

      t.timestamps
    end
    
    add_index :judge_property_declarations, [:judge_id, :year], unique: true
    add_index :judge_property_declarations, [:year, :judge_id], unique: true
  end
end
