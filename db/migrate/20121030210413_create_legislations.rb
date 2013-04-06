class CreateLegislations < ActiveRecord::Migration
  def change
    create_table :legislations do |t|
      t.string  :value,             null: false, limit: 500
      t.string  :value_unprocessed, null: false, limit: 500

      t.integer :number
      t.integer :year
      t.string  :name
      t.string  :section
      t.string  :paragraph
      t.string  :letter
      
      t.timestamps
    end
    
    add_index :legislations, :value, unique: true
  end
end
