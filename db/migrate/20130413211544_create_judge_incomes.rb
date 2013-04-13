class CreateJudgeReceipts < ActiveRecord::Migration
  def change
    create_table :judge_incomes do |t|
      t.references :judge_property_declaration, null: false
      
      t.string  :description, null: false
      t.decimal :value,       null: false, precision: 12, scale: 2
      
      t.timestamps
    end
    
    add_index :judge_incomes, [:judge_property_declaration_id, :description], unique: true
    
    add_index :judge_incomes, :description
  end
end
