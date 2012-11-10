class CreateLegislations < ActiveRecord::Migration
  def change
    create_table :legislations do |t|
      t.string  :value,             null: false
      t.string  :value_unprocessed, null: false

      t.integer :number,    null: false
      t.integer :year,      null: false
      t.string  :name,      null: false
      t.string  :section,   null: false
      t.string  :paragraph, null: false
      t.string  :letter,    null: true
      
      t.timestamps
    end
    
    add_index :legislations, :value, unique: true
    
    add_index :legislations, [:number, :year, :name, :section, :paragraph, :letter],
               unique: true, name: 'index_legislations_on_identifiers'
  end
end
