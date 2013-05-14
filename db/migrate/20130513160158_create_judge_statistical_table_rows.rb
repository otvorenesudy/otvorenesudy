class CreateJudgeStatisticalTableRows < ActiveRecord::Migration
  def change
    create_table :judge_statistical_table_rows do |t|
      t.references :judge_statistical_table,          null: false
      t.references :judge_statistical_table_row_name, null: false

      t.timestamps
    end
    
    add_index :judge_statistical_table_rows, [:judge_statistical_table_id, :judge_statistical_table_row_name_id],
               unique: true, name: 'index_judge_statistical_table_rows_on_unique_values'
  end
end
