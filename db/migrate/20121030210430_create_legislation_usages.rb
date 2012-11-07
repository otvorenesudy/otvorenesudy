class CreateLegislationUsages < ActiveRecord::Migration
  def change
    create_table :legislation_usages do |t|
      t.references :legislation, null: false
      t.references :decree,      null: false

      t.timestamps
    end
    
    add_index :legislation_usages, [:legislation_id, :decree_id], unique: true
    add_index :legislation_usages, [:decree_id, :legislation_id], unique: true
  end
end
