class AllowBlankJudgesForHearingsAndDecrees < ActiveRecord::Migration
  def up
    change_column :judgings, :judge_id, :integer, null: true
    change_column :judgements, :judge_id, :integer, null: true
  end

  def down
    change_column :judgings, :judge_id, :integer, null: false
    change_column :judgements, :judge_id, :integer, null: false
  end
end
