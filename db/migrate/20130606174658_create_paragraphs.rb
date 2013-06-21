class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.integer :legislation, null: false
      t.string  :number,      null: false
      t.string  :description, null: false

      t.timestamps
    end

    add_index :paragraphs, [:legislation, :number], unique: true
  end
end
