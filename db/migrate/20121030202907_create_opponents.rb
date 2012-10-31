class CreateOpponents < ActiveRecord::Migration
  def change
    create_table :opponents do |t|
      t.references :hearing, null: false
      
      t.string :name, null: false

      t.timestamps
    end
    
    add_index :opponents, :hearing_id
    add_index :opponents, :name
  end
end
