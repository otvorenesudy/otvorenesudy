class CreateHearings < ActiveRecord::Migration
  def change
    create_table :hearings do |t|
      t.string :uri, null: false
      
      t.references :proceeding
      t.references :court
      
      t.references :hearing_type,    null: false
      t.references :hearing_section
      t.references :hearing_subject
      t.references :hearing_form
      
      t.string :case_number
      t.string :file_number
      
      t.datetime :date
      t.string   :room
      
      t.string     :special_type
      t.datetime   :commencement_date
      t.references :chair_judge
      t.boolean    :chair_judge_matched_exactly
      t.string     :chair_judge_name_unprocessed
      t.boolean    :selfjudge

      t.text :note

      t.timestamps
    end
    
    add_index :hearings, :uri, unique: true
    
    add_index :hearings, :proceeding_id
    add_index :hearings, :court_id
    
    add_index :hearings, :case_number
    add_index :hearings, :file_number
    
    add_index :hearings, :chair_judge_id
    add_index :hearings, :chair_judge_name_unprocessed
  end
end
