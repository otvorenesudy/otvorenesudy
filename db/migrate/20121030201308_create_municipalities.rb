class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name, null: false

      t.timestamps
    end
    
    add_index :municipalities, :name, unique: true
  end
end
