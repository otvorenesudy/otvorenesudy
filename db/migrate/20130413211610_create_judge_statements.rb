class CreateJudgeStatements < ActiveRecord::Migration
  def change
    create_table :judge_statements do |t|

      t.timestamps
    end
  end
end
