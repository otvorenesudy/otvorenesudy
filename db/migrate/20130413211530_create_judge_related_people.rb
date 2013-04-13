class CreateJudgeRelatedPeople < ActiveRecord::Migration
  def change
    create_table :judge_related_people do |t|

      t.timestamps
    end
  end
end
