class CreateLegislationNames < ActiveRecord::Migration
  def change
    create_table :legislation_names do |t|
      t.string :value,     null: false
      t.string :paragraph, null: false

      t.timestamps
    end

    add_index :legislation_names, :value, unique: true
  end
end
