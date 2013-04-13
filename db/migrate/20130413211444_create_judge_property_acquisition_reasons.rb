class CreateJudgePropertyAcquisitionReasons < ActiveRecord::Migration
  def change
    create_table :judge_property_acquisition_reasons do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_property_acquisition_reasons, :value, unique: true
  end
end
