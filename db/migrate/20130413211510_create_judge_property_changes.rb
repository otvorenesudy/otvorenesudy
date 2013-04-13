class CreateJudgePropertyChanges < ActiveRecord::Migration
  def change
    create_table :judge_property_changes do |t|

      t.timestamps
    end
  end
end
