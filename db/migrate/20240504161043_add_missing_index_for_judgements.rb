class AddMissingIndexForJudgements < ActiveRecord::Migration
  def up
    add_index :judgements, %i[decree_id judge_name_unprocessed], unique: true
  end

  def down
    remove_index :judgements, %i[decree_id judge_name_unprocessed]
  end
end
