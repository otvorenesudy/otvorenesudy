class CreateJudgeStatisticalTableColumnNames < ActiveRecord::Migration
  def change
    create_table :judge_statistical_table_column_names do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :judge_statistical_table_column_names, :value, unique: true
  end
end
