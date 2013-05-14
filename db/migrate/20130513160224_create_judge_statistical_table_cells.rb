class CreateJudgeStatisticalTableCells < ActiveRecord::Migration
  def change
    create_table :judge_statistical_table_cells do |t|
      t.references :judge_statistical_table_column, null: false
      t.references :judge_statistical_table_row,    null: false
      
      t.string :value
      
      t.timestamps
    end
    
    add_index :judge_statistical_table_cells, [:judge_statistical_table_column_id, :judge_statistical_table_row_id],
               unique: true, name: 'index_judge_statistical_table_cells_on_unique_values'

    add_index :judge_statistical_table_cells, [:judge_statistical_table_row_id, :judge_statistical_table_column_id],
               unique: true, name: 'index_judge_statistical_table_cells_on_unique_values_reversed'
  end
end
