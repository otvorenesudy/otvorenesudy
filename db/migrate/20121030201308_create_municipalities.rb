class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name, null: false
      
      t.integer :zipcode, null: false

      t.timestamps
    end
    
    add_index :municipalities, :name,    unique: true
    add_index :municipalities, :zipcode, unique: true
  end
end
