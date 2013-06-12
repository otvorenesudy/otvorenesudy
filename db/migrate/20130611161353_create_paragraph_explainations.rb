class CreateParagraphExplainations < ActiveRecord::Migration
  def change
    create_table :paragraph_explainations do |t|
      t.references :paragraph,   null: false
      t.references :explainable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :paragraph_explainations, [:paragraph_id, :explainable_id, :explainable_type],
               unique: true, name: 'index_paragraph_explainations_on_unique_values'

    add_index :paragraph_explainations, [:explainable_id, :explainable_type, :paragraph_id],
               unique: true, name: 'index_paragraph_explainations_on_unique_values_reversed'
  end
end
