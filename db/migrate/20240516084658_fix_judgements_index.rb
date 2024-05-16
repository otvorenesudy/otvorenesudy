class FixJudgementsIndex < ActiveRecord::Migration
  def up
    remove_index :judgements, %i[decree_id judge_name_unprocessed]
  end

  def down
    add_index :judgements, %i[decree_id judge_name_unprocessed], unique: true
  end
end
