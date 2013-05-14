class CreateDecrees < ActiveRecord::Migration
  def change
    create_table :decrees do |t|
      t.string     :uri,    null: false
      t.references :source, null: false
      
      t.references :proceeding
      t.references :court
      
      t.references :decree_form
            
      t.string :case_number
      t.string :file_number
      
      t.date   :date
      t.string :ecli

      t.references :legislation_area
      t.references :legislation_subarea
      
      t.text :text

      t.timestamps
    end
    
    add_index :decrees, :uri, unique: true
    add_index :decrees, :source_id
    
    add_index :decrees, :proceeding_id
    add_index :decrees, :court_id

    add_index :decrees, :decree_form_id
    
    add_index :decrees, :case_number
    add_index :decrees, :file_number
  end
end
