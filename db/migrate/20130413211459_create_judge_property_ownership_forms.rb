class CreateJudgePropertyOwnershipForms < ActiveRecord::Migration
  def change
    create_table :judge_property_ownership_forms do |t|

      t.timestamps
    end
  end
end
