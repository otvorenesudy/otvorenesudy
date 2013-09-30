class RenameParagraphExplainationToParagraphExplanation < ActiveRecord::Migration
  def up
    rename_table :paragraph_explainations, :paragraph_explanations
  end

  def down
    rename_table :paragraph_explanations, :paragraph_explainations
  end
end
