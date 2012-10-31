class CreateHearingSections < ActiveRecord::Migration
  def change
    create_table :hearing_sections do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :hearing_sections, :value, unique: true
  end
end
