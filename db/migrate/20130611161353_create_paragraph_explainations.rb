class CreateParagraphExplanations < ActiveRecord::Migration
  def change
    create_table :paragraph_explains do |t|
      t.references :paragraph,   null: false
      t.references :explainable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :paragraph_explains, [:paragraph_id, :explainable_id, :explainable_type], unique: true
    add_index :paragraph_explains, [:explainable_id, :explainable_type, :paragraph_id], unique: true
  end
end
