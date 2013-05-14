class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :module, null: false
      t.string :name,   null: false
      t.string :uri,    null: false

      t.timestamps
    end
  end
  
  add_index :sources, :module, unique: true
  add_index :sources, :name,   unique: true
  add_index :sources, :uri,    unique: true
end
