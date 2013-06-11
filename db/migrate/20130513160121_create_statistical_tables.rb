class CreateStatisticalTables < ActiveRecord::Migration
  def change
    create_table :statistical_tables do |t|
      t.references :statistical_summary,    null: false, polymorphic: true
      t.references :statistical_table_name, null: false

      t.timestamps
    end

    add_index :statistical_tables, [:statistical_summary_id, :statistical_summary_type],
               unique: true, name: 'index_statistical_tables_on_summary_by_type'

    add_index :statistical_tables, :statistical_table_name_id
  end
end
