class CreateStatisticalTableRowNames < ActiveRecord::Migration
  def change
    create_table :statistical_table_row_names do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :statistical_table_row_names, :value, unique: true
  end
end
