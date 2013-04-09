class CreatePartialJudgings < ActiveRecord::Migration
  def change
    create_table :partial_judgings do |t|
      t.references :hearing, null: false
      
      t.string  :judge_name,             null: false
      t.string  :judge_name_unprocessed, null: false
      t.boolean :judge_chair,            null: false

      t.timestamps
    end
    
    add_index :partial_judgings, [:hearing_id, :judge_name], unique: true
    add_index :partial_judgings, [:judge_name, :hearing_id], unique: true
    
    add_index :partial_judgings, :judge_name_unprocessed
  end
end
