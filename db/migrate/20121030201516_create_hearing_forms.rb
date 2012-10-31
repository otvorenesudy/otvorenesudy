class CreateHearingForms < ActiveRecord::Migration
  def change
    create_table :hearing_forms do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :hearing_forms, :value, unique: true
  end
end
