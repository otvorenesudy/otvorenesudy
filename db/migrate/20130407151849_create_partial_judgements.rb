class CreatePartialJudgements < ActiveRecord::Migration
  def change
    create_table :partial_judgements do |t|
      t.references :decree, null: false
      
      t.string :judge_name,             null: false
      t.string :judge_name_unprocessed, null: false

      t.timestamps
    end
    
    add_index :partial_judgements, [:decree_id, :judge_name], unique: true
    add_index :partial_judgements, [:judge_name, :decree_id], unique: true
    
    add_index :partial_judgements, :judge_name_unprocessed
  end
end
