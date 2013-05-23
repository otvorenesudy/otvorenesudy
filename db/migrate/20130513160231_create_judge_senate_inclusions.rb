class CreateJudgeSenateInclusions < ActiveRecord::Migration
  def change
    create_table :judge_senate_inclusions do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :judge_senate_inclusions, :value, unique: true
  end
end
