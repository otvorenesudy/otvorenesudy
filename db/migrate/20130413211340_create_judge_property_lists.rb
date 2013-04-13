class CreateJudgePropertyLists < ActiveRecord::Migration
  def change
    create_table :judge_property_lists do |t|

      t.timestamps
    end
  end
end
