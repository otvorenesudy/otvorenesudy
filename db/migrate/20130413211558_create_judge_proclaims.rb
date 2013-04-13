class CreateJudgeProclaims < ActiveRecord::Migration
  def change
    create_table :judge_proclaims do |t|

      t.timestamps
    end
  end
end
