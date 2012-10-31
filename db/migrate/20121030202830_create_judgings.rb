class CreateJudgings < ActiveRecord::Migration
  def change
    create_table :judgings do |t|
      t.references :judge,   null: false
      t.references :hearing, null: false

      t.timestamps
    end
    
    add_index :judgings, :judge_id
    add_index :judgings, :hearing_id
  end
end
