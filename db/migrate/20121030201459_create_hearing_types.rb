class CreateHearingTypes < ActiveRecord::Migration
  def change
    create_table :hearing_types do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :hearing_types, :value, unique: true
  end
end
