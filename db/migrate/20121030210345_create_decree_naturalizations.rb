class CreateDecreeNaturalizations < ActiveRecord::Migration
  def change
    create_table :decree_naturalizations do |t|
      t.references :decree,        null: false
      t.references :decree_nature, null: false
      
      t.timestamps
    end

    add_index :decree_naturalizations, [:decree_id, :decree_nature_id], unique: true
    add_index :decree_naturalizations, [:decree_nature_id, :decree_id], unique: true
  end
end
