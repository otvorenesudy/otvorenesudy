class CreateJudgeDesignations < ActiveRecord::Migration
  def change
    create_table :judge_designations do |t|
      t.references :judge, null: false

      t.references :judge_designation_type
      t.date :date, null: false

      t.timestamps
    end

    add_index :judge_designations, :judge_id
  end
end
