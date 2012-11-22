class CreateProceedings < ActiveRecord::Migration
  def change
    create_table :proceedings do |t|
      t.string :file_number
      
      t.timestamps
    end
    
    add_index :proceedings, :file_number, unique: true
  end
end
