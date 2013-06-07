class CreateLegislationTitles < ActiveRecord::Migration
  def change
    create_table :legislation_titles do |t|
      t.string :paragraph, null: false
      t.string :value,     null: false

      t.timestamps
    end

    add_index :legislation_titles, :paragraph
    add_index :legislation_titles, :value
    add_index :legislation_titles, [:paragraph, :value], unique: true
  end
end
