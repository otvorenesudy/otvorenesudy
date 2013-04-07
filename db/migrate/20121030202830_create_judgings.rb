class CreateJudgings < ActiveRecord::Migration
  def change
    create_table :judgings do |t|
      t.references :hearing, null: false
      t.references :judge,   null: false
      
      t.decimal :judge_name_similarity,  null: false, precision: 3, scale: 2
      t.string  :judge_name_unprocessed, null: false
      t.boolean :judge_chair,            null: false

      t.timestamps
    end
    
    add_index :judgings, [:hearing_id, :judge_id], unique: true
    add_index :judgings, [:judge_id, :hearing_id], unique: true
    
    add_index :judgings, :judge_name_unprocessed
  end
end
