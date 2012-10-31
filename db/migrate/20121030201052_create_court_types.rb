class CreateCourtTypes < ActiveRecord::Migration
  def change
    create_table :court_types do |t|
      t.string :value, null: false
      
      t.timestamps
    end

    add_index :court_types, :value, unique: true
  end
end
