class CreateProposers < ActiveRecord::Migration
  def change
    create_table :proposers do |t|
      t.references :hearing, null: false
      
      t.string :name, null: false

      t.timestamps
    end
    
    add_index :proposers, [:hearing_id, :name], unique: true

    add_index :proposers, :name
  end
end
