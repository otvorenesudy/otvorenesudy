class CreateJudgeStatisticalTables < ActiveRecord::Migration
  def change
    create_table :judge_statistical_tables do |t|
      t.references :judge_statistical_summary,    null: false
      t.references :judge_statistical_table_name, null: false

      t.timestamps
    end
    
    add_index :judge_statistical_tables, :judge_statistical_summary_id,
               name: 'index_judge_statistical_tables_on_summaries'
    
    add_index :judge_statistical_tables, :judge_statistical_table_name_id,
               name: 'index_judge_statistical_tables_on_table_names'
  end
end
