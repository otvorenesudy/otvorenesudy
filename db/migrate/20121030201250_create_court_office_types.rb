class CreateCourtOfficeTypes < ActiveRecord::Migration
  def change
    create_table :court_office_types do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :court_office_types, :value, unique: true
  end
end
