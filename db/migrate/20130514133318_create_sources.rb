class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :module, null: false
      t.string :name,   null: false
      
      t.string :base_uri, null: false
      t.string :data_uri, null: false

      t.timestamps
    end
  end
  
  add_index :sources, :module, unique: true
  add_index :sources, :name
  
  add_index :sources, :base_uri, unique: true
  add_index :sources, :data_uri
end
