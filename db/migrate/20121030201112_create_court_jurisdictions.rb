class CreateCourtJurisdictions < ActiveRecord::Migration
  def change
    create_table :court_jurisdictions do |t|
      t.references :court_proceeding_type, null: false
      t.references :municipality,          null: false

      t.timestamps
    end
    
    add_index :court_jurisdictions, :court_proceeding_type_id
    add_index :court_jurisdictions, :municipality_id
  end
end
