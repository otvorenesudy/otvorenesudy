class CreateJudgePropertyCategories < ActiveRecord::Migration
  def change
    create_table :judge_property_categories do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_property_categories, :value, unique: true
  end
end
