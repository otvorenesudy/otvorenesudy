class CreateJudgePropertyCategories < ActiveRecord::Migration
  def change
    create_table :judge_property_categories do |t|

      t.timestamps
    end
  end
end
