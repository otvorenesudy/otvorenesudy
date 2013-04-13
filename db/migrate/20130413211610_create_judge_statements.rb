class CreateJudgeStatements < ActiveRecord::Migration
  def change
    create_table :judge_statements do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_statements, :value, unique: true
  end
end
