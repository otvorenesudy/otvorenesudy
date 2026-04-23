class AddTokenToSubscriptions < ActiveRecord::Migration
  def up
    add_column :subscriptions, :token, :string

    Subscription.reset_column_information
    Subscription.find_each { |subscription| subscription.update_column(:token, Subscription.generate_unique_token) }

    change_column_null :subscriptions, :token, false
    add_index :subscriptions, :token, unique: true
  end

  def down
    remove_index :subscriptions, :token
    remove_column :subscriptions, :token
  end
end
