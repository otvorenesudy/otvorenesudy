class CreateCourts < ActiveRecord::Migration
  def change
    create_table :courts do |t|
      t.references :court_type,         null: false
      t.references :court_jurisdiction, null: true
      
      t.references :municipality, null: false

      t.string :name,   null: false
      t.string :street, null: false
      
      t.string :email
      t.string :phone
      t.string :fax
      
      t.string :media_person_name
      t.string :media_phone
      
      t.references :information_center
      t.references :registry_center
      t.references :business_registry_center
      
      t.integer :latitude
      t.integer :longitude

      t.timestamps
    end
    
    add_index :courts, :court_type_id
    add_index :courts, :court_jurisdiction_id
    add_index :courts, :municipality_id
    
    add_index :courts, :name, unique: true
  end
end
