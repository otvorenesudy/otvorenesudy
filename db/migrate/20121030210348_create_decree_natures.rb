class CreateDecreeNatures < ActiveRecord::Migration
  def change
    create_table :decree_natures do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :decree_natures, :value, unique: true
  end
end
