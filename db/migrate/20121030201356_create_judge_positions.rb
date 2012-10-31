class CreateJudgePositions < ActiveRecord::Migration
  def change
    create_table :judge_positions do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_positions, :value, unique: true
  end
end
