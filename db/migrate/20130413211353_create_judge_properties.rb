class CreateJudgeProperties < ActiveRecord::Migration
  def change
    create_table :judge_properties do |t|

      t.timestamps
    end
  end
end
