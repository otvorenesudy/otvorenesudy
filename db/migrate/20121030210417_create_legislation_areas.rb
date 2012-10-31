class CreateLegislationAreas < ActiveRecord::Migration
  def change
    create_table :legislation_areas do |t|
      t.string :value, null: false

      t.timestamps
    end
    
    add_index :legislation_areas, :value
  end
end
