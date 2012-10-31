class CreateJudges < ActiveRecord::Migration
  def change
    create_table :judges do |t|
      t.string :name, null: false

      t.timestamps
    end
    
    add_index :judges, :name, unique: true
  end
end
