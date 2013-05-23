class CreateStatisticalTableColumns < ActiveRecord::Migration
  def change
    create_table :statistical_table_columns do |t|
      t.references :statistical_table,             null: false
      t.references :statistical_table_column_name, null: false

      t.timestamps
    end

    add_index :statistical_table_columns, [:statistical_table_id, :statistical_table_column_name_id],
               unique: true, name: 'index_statistical_table_columns_on_unique_values'
  end
end
