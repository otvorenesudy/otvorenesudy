class CreateJudgePropertyLists < ActiveRecord::Migration
  def change
    create_table :judge_property_lists do |t|
      t.references :judge_property_declaration, null: false
      t.references :judge_property_category,    null: false

      t.timestamps
    end
    
    add_index :judge_property_lists, [:judge_property_declaration_id, :judge_property_category_id], unique: true
    add_index :judge_property_lists, [:judge_property_category_id, :judge_property_declaration_id], unique: true
  end
end
