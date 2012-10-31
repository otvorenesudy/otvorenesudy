class CreateLegislationSubareas < ActiveRecord::Migration
  def change
    create_table :legislation_subareas do |t|
      t.references :legislation_area, null: false
      
      t.string :value, null: false

      t.timestamps
    end
    
    add_index :legislation_subareas, :legislation_area_id
    add_index :legislation_subareas, :value
  end
end
