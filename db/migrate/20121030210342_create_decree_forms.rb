class CreateDecreeForms < ActiveRecord::Migration
  def change
    create_table :decree_forms do |t|
      t.string :value, null: false
      t.string :code,  null: false
      
      t.timestamps
    end

    add_index :decree_forms, :value, unique: true
  end
end
