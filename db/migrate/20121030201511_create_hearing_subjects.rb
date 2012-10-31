class CreateHearingSubjects < ActiveRecord::Migration
  def change
    create_table :hearing_subjects do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :hearing_subjects, :value, unique: true
  end
end
