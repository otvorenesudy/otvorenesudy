class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name, null: false
      
      t.string :zipcode, null: false

      t.timestamps
    end
    
    add_index :municipalities, :name, unique: true
    add_index :municipalities, :zipcode
  end
end
