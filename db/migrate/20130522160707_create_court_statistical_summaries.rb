class CreateCourtStatisticalSummaries < ActiveRecord::Migration
  def change
    create_table :court_statistical_summaries do |t|
      t.string     :uri,    null: false
      t.references :source, null: false

      t.references :court, null: false

      t.integer :year, null: false

      t.timestamps
    end

    add_index :court_statistical_summaries, :uri
    add_index :court_statistical_summaries, :source_id

    add_index :court_statistical_summaries, [:court_id, :year],
      name: 'index_court_statistical_summaries_on_court_and_year', unique: true

    add_index :court_statistical_summaries, :court_id

    add_index :court_statistical_summaries, :year
  end
end
