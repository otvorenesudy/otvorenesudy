class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user,   null: false
      t.references :query,  null: false
      t.references :period, null: false

      t.timestamps
    end

    add_index :subscriptions, [:user_id, :query_id, :period_id], unique: true

    add_index :subscriptions, :user_id
    add_index :subscriptions, :query_id
    add_index :subscriptions, :period_id
  end
end
