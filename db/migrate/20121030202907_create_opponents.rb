class CreateOpponents < ActiveRecord::Migration
  def change
    create_table :opponents do |t|
      t.references :hearing, null: false
      
      t.string :name,             null: false
      t.string :name_unprocessed, null: false

      t.timestamps
    end
    
    add_index :opponents, [:hearing_id, :name], unique: true
    
    add_index :opponents, :name
    add_index :opponents, :name_unprocessed
  end
end
