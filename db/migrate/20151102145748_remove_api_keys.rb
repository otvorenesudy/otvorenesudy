class RemoveApiKeys < ActiveRecord::Migration
  def up
    drop_table :api_keys
  end

  def down
    create_table :api_keys do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :api_keys, :value, unique: true
  end
end
