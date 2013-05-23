class CreateStatisticalTableCells < ActiveRecord::Migration
  def change
    create_table :statistical_table_cells do |t|
      t.references :statistical_table_column, null: false
      t.references :statistical_table_row,    null: false

      t.string :value

      t.timestamps
    end

    add_index :statistical_table_cells, [:statistical_table_column_id, :statistical_table_row_id],
               unique: true, name: 'index_statistical_table_cells_on_unique_values'

    add_index :statistical_table_cells, [:statistical_table_row_id, :statistical_table_column_id],
               unique: true, name: 'index_statistical_table_cells_on_unique_values_reversed'
  end
end
