class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.references :court,          null: false
      t.references :judge,          null: false
      t.references :judge_position, null: true 

      t.boolean :active, null: false
      
      t.string :note

      t.timestamps
    end
    
    add_index :employments, [:court_id, :judge_id]
    add_index :employments, [:judge_id, :court_id]
  end
end
