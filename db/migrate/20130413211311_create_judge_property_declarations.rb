class CreateJudgePropertyDeclarations < ActiveRecord::Migration
  def change
    create_table :judge_property_declarations do |t|
      t.string     :uri,    null: false
      t.references :source, null: false
      
      t.references :court, null: false
      t.references :judge, null: false
      
      t.integer :year, null: false 

      t.timestamps
    end
    
    add_index :judge_property_declarations, :uri, unique: true
    add_index :judge_property_declarations, :source_id
    
    add_index :judge_property_declarations, :court_id
    
    add_index :judge_property_declarations, [:judge_id, :year], unique: true
    add_index :judge_property_declarations, [:year, :judge_id], unique: true
  end
end
