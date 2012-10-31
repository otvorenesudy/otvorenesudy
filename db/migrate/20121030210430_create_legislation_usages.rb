class CreateLegislationUsages < ActiveRecord::Migration
  def change
    create_table :legislation_usages do |t|
      t.references :legislation, null: false
      t.references :decree,      null: false

      t.timestamps
    end
    
    add_index :legislation_usages, :legislation_id
    add_index :legislation_usages, :decree_id
  end
end
