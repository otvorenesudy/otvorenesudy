class CreateHearings < ActiveRecord::Migration
  def change
    create_table :hearings do |t|
      t.references :proceeding, null: true
      t.references :court,      null: false
      
      t.references :hearing_type,    null: false
      t.references :hearing_section, null: true
      t.references :hearing_subject, null: true
      t.references :hearing_form,    null: true
      
      t.string :case_number
      t.string :file_number
      
      t.datetime :date
      t.string   :room
      
      t.string     :special_type
      t.datetime   :commencement_date
      t.references :chair_judge
      t.boolean    :selfjudge

      t.string :note

      t.timestamps
    end
    
    add_index :hearings, :proceeding_id
    add_index :hearings, :court_id
  end
end
