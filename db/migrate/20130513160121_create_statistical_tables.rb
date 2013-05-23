class CreateStatisticalTables < ActiveRecord::Migration
  def change
    create_table :statistical_tables do |t|
      t.integer    :statistical_summary_id,       null: false
      t.string     :statistical_summary_type,     null: false
      t.references :statistical_table_name,       null: false

      t.timestamps
    end

    add_index :statistical_tables, :statistical_summary_id
    add_index :statistical_tables, :statistical_summary_type
    add_index :statistical_tables, [:statistical_summary_id, :statistical_summary_type],
      name: "index_statistical_tables_on_summary_id_and_type"
    add_index :statistical_tables, :statistical_table_name_id
  end
end
