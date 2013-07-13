class CreateJudgeStatisticalSummaries < ActiveRecord::Migration
  def change
    create_table :judge_statistical_summaries do |t|
      t.string     :uri,    null: false
      t.references :source, null: false

      t.references :court,                  null: false
      t.references :judge,                  null: false
      t.references :judge_senate_inclusion

      # TODO: non-null constraint for author and date
      t.string  :author
      t.integer :year,   null: false
      t.date    :date

      t.integer :days_worked
      t.integer :days_heard
      t.integer :days_used

      t.integer :released_constitutional_decrees
      t.integer :delayed_constitutional_decrees

      t.text  :idea_reduction_reasons
      t.text  :educational_activities
      t.text  :substantiation_notes
      t.text  :court_chair_actions

      t.timestamps
    end

    add_index :judge_statistical_summaries, :uri
    add_index :judge_statistical_summaries, :source_id

    add_index :judge_statistical_summaries, :court_id, :judge_id, :year, unique: true

    add_index :judge_statistical_summaries, :court_id
    add_index :judge_statistical_summaries, :judge_id

    add_index :judge_statistical_summaries, :author
    add_index :judge_statistical_summaries, :year
    add_index :judge_statistical_summaries, :date
  end
end
