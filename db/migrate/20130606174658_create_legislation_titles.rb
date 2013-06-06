class CreateLegislationTitles < ActiveRecord::Migration
  def change
    create_table :legislation_titles do |t|
      t.string :letter
      t.string :paragraph, null: false
      t.string :section
      t.string :value,     null: false

      t.timestamps
    end

    add_index :legislation_titles, :letter
    add_index :legislation_titles, :paragraph
    add_index :legislation_titles, :value
    add_index :legislation_titles, [:paragraph, :letter], unique: true
    add_index :legislation_titles, [:paragraph, :letter, :value], unique: true
  end
end
