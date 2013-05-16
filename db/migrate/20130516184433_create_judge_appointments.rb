class CreateJudgeAppointments < ActiveRecord::Migration
  def change
    create_table :judge_appointments do |t|
      t.references :judge, null: false
      
      t.date :date, null: false
      
      t.timestamps
    end
    
    add_index :judge_appointments, :judge_id
  end
end
