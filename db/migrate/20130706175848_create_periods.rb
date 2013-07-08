class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string  :name,  null: false
      t.integer :value, null: false

      t.timestamps
    end

    add_index :periods, :name, unique: true
  end
end
