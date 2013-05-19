class CreateJudgeDesignationTypes < ActiveRecord::Migration
  def change
    create_table :judge_designation_types do |t|
      t.string :value, null: false

      t.timestamps
    end
    
    add_index :judge_designation_types, :value, unique: true
  end
end
