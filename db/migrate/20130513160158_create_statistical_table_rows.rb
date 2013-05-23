class CreateStatisticalTableRows < ActiveRecord::Migration
  def change
    create_table :statistical_table_rows do |t|
      t.references :statistical_table,          null: false
      t.references :statistical_table_row_name, null: false

      t.timestamps
    end

    add_index :statistical_table_rows, [:statistical_table_id, :statistical_table_row_name_id],
               unique: true, name: 'index_statistical_table_rows_on_unique_values'
  end
end
