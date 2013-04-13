class CreateJudgePropertyDeclarations < ActiveRecord::Migration
  def change
    create_table :judge_property_declarations do |t|

      t.timestamps
    end
  end
end
