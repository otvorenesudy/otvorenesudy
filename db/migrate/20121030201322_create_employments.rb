class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.references :court,          null: false
      t.references :judge,          null: false
      t.references :judge_position, null: false  

      t.boolean :active, null: false
      
      t.string :note

      t.timestamps
    end
    
    add_index :employments, :court_id
    add_index :employments, :judge_id
  end
end
