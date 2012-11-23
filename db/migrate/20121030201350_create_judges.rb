class CreateJudges < ActiveRecord::Migration
  def change
    create_table :judges do |t|
      t.string :name,             null: false
      t.string :name_unprocessed, null: false

      t.string :prefix
      t.string :first,   null: false
      t.string :middle
      t.string :last,    null: false
      t.string :suffix
      t.string :addition

      t.timestamps
    end
    
    add_index :judges, :name,             unique: true
    add_index :judges, :name_unprocessed, unique: true
    
    add_index :judges, [:first, :middle, :last]
    add_index :judges, [:last, :middle, :first]
  end
end
