class AddMissingIndexForJudgements < ActiveRecord::Migration
  def up
    judgements = Judgement.group(:decree_id, :judge_name_unprocessed).having('count(*) > 1').count

    judgements.each do |(decree_id, judge_name_unprocessed), _|
      id, *duplicate_ids =
        Judgement.where(decree_id: decree_id, judge_name_unprocessed: judge_name_unprocessed).order(:id).pluck(:id)

      Judgement.where(id: duplicate_ids).delete_all
    end

    add_index :judgements, %i[decree_id judge_name_unprocessed], unique: true
  end

  def down
    remove_index :judgements, %i[decree_id judge_name_unprocessed]
  end
end
