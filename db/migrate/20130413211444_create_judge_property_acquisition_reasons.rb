class CreateJudgePropertyAcquisitionReasons < ActiveRecord::Migration
  def change
    create_table :judge_property_acquisition_reasons do |t|

      t.timestamps
    end
  end
end
