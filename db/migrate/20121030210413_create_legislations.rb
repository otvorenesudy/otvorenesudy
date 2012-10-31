class CreateLegislations < ActiveRecord::Migration
  def change
    create_table :legislations do |t|
      t.integer :number,    null: false
      t.integer :year,      null: false
      t.string  :name,      null: false
      t.string  :section,   null: false
      t.string  :paragraph, null: false
      t.string  :letter,    null: true
      
      t.timestamps
    end
    
    add_index :legislations, :number
  end
end
