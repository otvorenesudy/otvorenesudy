class CreateJudgePropertyChanges < ActiveRecord::Migration
  def change
    create_table :judge_property_changes do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_property_changes, :value, unique: true
  end
end
