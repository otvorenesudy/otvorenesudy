class CreateJudgeStatisticalSummaries < ActiveRecord::Migration
  def change
    create_table :judge_statistical_summaries do |t|
      t.references :court,                  null: false
      t.references :judge,                  null: false
      t.references :judge_senate_inclusion

      t.string  :author, null: false
      t.integer :year,   null: false
      t.date    :date,   null: false
      
      t.integer :days_worked
      t.integer :days_heard
      t.integer :days_used
      
      t.integer :released_constitutional_decrees
      t.integer :delayed_constitutional_decrees
      
      t.string  :idea_reduction_reasons, limit: 510
      t.string  :educational_activities, limit: 510
      t.string  :substantiation_notes,   limit: 510
      t.string  :court_chair_actions,    limit: 510

      t.timestamps
    end
    
    add_index :judge_statistical_summaries, :court_id
    add_index :judge_statistical_summaries, :judge_id
    
    add_index :judge_statistical_summaries, :author
    add_index :judge_statistical_summaries, :year
    add_index :judge_statistical_summaries, :date
  end
end
