class CreateSelectionProcedures < ActiveRecord::Migration
  def change
    create_table :selection_procedures do |t|
      t.string     :uri,    null: false
      t.references :source, null: false

      t.references :court, null: true

      t.string :organization_name,             null: false
      t.string :organization_name_unprocessed, null: false
      t.text   :organization_description,      null: false

      t.date :date, null: false

      t.text   :description
      t.string :place
      t.string :position
      t.string :state
      t.string :workplace

      t.datetime :closed_at

      t.timestamps
    end

    add_index :selection_procedures, :uri, unique: false
    add_index :selection_procedures, :source_id

    add_index :selection_procedures, :court_id

    add_index :selection_procedures, :organization_name
    add_index :selection_procedures, :organization_name_unprocessed

    add_index :selection_procedures, :date
    add_index :selection_procedures, :closed_at
  end
end
