class CreateJudgeReceipts < ActiveRecord::Migration
  def change
    create_table :judge_receipts do |t|

      t.timestamps
    end
  end
end
