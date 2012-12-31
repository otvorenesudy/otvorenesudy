class CreateJudgements < ActiveRecord::Migration
  def change
    create_table :judgements do |t|
      t.references :judge,  null: false
      t.references :decree, null: false
      
      t.decimal :judge_name_similarity,  null: false, precision: 3, scale: 2
      t.string  :judge_name_unprocessed, null: false

      t.timestamps
    end
    
    add_index :judgements, [:judge_id, :decree_id], unique: true
    add_index :judgements, [:decree_id, :judge_id], unique: true
    
    add_index :judgements, :judge_name_unprocessed
  end
end
