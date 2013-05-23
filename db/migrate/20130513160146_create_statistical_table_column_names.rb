class CreateStatisticalTableColumnNames < ActiveRecord::Migration
  def change
    create_table :statistical_table_column_names do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :statistical_table_column_names, :value, unique: true
  end
end
