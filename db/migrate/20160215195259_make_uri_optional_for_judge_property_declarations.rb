class MakeUriOptionalForJudgePropertyDeclarations < ActiveRecord::Migration
  def up
    change_column :judge_property_declarations, :uri, :string, null: true
  end

  def down
    # TODO fix records with NULL as uri
    change_column :judge_property_declarations, :uri, :string, null: false
  end
end
