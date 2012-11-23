class CreateJudgings < ActiveRecord::Migration
  def change
    create_table :judgings do |t|
      t.references :judge,                  null: false
      t.boolean    :judge_matched_exactly,  null: false
      t.string     :judge_name_unprocessed, null: false

      t.references :hearing, null: false

      t.timestamps
    end
    
    add_index :judgings, [:judge_id, :hearing_id], unique: true
    add_index :judgings, [:hearing_id, :judge_id], unique: true
  end
end
