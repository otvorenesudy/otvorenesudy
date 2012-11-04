class CreateDefendants < ActiveRecord::Migration
  def change
    create_table :defendants do |t|
      t.references :hearing, null: false
      
      t.string :name, null: false

      t.timestamps
    end
    
    add_index :defendants, [:hearing_id, :name], unique: true
    
    add_index :defendants, :name
  end
end
