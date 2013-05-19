class CreateJudgeDesignationTypes < ActiveRecord::Migration
  def change
    create_table :judge_designation_types do |t|
      t.string :value

      t.timestamps
    end
  end
end
