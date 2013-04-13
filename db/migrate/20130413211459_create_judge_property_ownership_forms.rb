class CreateJudgePropertyOwnershipForms < ActiveRecord::Migration
  def change
    create_table :judge_property_ownership_forms do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_property_ownership_forms, :value, unique: true
  end
end
