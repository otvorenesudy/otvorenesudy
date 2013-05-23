class CreateJudgeDesignations < ActiveRecord::Migration
  def change
    create_table :judge_designations do |t|
      t.string     :uri,    null: false
      t.references :source, null: false

      t.references :judge,                  null: false
      t.references :judge_designation_type, null: true

      t.date :date, null: false

      t.timestamps
    end

    add_index :judge_designations, :uri
    add_index :judge_designations, :source_id

    add_index :judge_designations, :judge_id
    add_index :judge_designations, :judge_designation_type_id

    add_index :judge_designations, :date
  end
end
