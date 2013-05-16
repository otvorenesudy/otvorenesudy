class CreateDecreePages < ActiveRecord::Migration
  def change
    create_table :decree_pages do |t|
      t.references :decree, null: false
      
      t.integer :number, null: false
      t.text    :text,   null: false
      
      t.timestamps
    end

    add_index :decree_pages, [:decree_id, :number], unique: true
  end
end
