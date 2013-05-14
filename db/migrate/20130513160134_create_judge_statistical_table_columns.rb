class CreateJudgeStatisticalTableColumns < ActiveRecord::Migration
  def change
    create_table :judge_statistical_table_columns do |t|
      t.references :judge_statistical_table,             null: false
      t.references :judge_statistical_table_column_name, null: false

      t.timestamps
    end
    
    add_index :judge_statistical_table_columns, [:judge_statistical_table_id, :judge_statistical_table_column_name_id],
               unique: true, name: 'index_judge_statistical_table_columns_on_unique_values'
  end
end
