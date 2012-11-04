class CreateAccusations < ActiveRecord::Migration
  def change
    create_table :accusations do |t|
      t.references :defendant, null: false
      
      t.string :value

      t.timestamps
    end
    
    add_index :accusations, [:defendant_id, :value], unique: true
  end
end
