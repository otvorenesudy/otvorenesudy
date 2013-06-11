class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :number,      null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :paragraphs, :number, unique: true
    add_index :paragraphs, :description
  end
end
