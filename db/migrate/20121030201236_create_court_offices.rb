class CreateCourtOffices < ActiveRecord::Migration
  def change
    create_table :court_offices do |t|
      t.references :court,             null: false
      t.references :court_office_type, null: false
      
      t.string :email
      t.string :phone
      
      t.string :hours_monday
      t.string :hours_tuesday
      t.string :hours_wednesday
      t.string :hours_thursday
      t.string :hours_friday
      
      t.text :note
      
      t.timestamps
    end
    
    add_index :court_offices, :court_id
  end
end
