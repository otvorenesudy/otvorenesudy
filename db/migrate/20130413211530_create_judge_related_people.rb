class CreateJudgeRelatedPeople < ActiveRecord::Migration
  def change
    create_table :judge_related_people do |t|
      t.references :judge_property_declaration, null: false
      
      t.string :name,        null: false
      t.string :institution, null: true
      t.string :function,    null: true

      t.timestamps
    end
    
    add_index :judge_related_people, [:judge_property_declaration_id, :name],
               unique: true, name: 'index_judge_related_people_on_unique_values'
    
    add_index :judge_related_people, :name
    add_index :judge_related_people, :institution
    add_index :judge_related_people, :function
  end
end
