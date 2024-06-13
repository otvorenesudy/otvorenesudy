class RemoveConstraintsOnJudgeNameUnprocessed < ActiveRecord::Migration
  def up
    change_column :judgings, :judge_name_unprocessed, :string, null: true
    change_column :judgements, :judge_name_unprocessed, :string, null: true
  end

  def down
    change_column :judgings, :judge_name_unprocessed, :string, null: false
    change_column :judgements, :judge_name_unprocessed, :string, null: false
  end
end
