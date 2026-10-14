# frozen_string_literal: true

# The token of each subscription's unsubscribe link: random, and unique as it includes the id.
class AddTokenToSubscriptions < ActiveRecord::Migration[8.1]
  def up
    add_column :subscriptions, :token, :string, limit: 255

    execute 'UPDATE subscriptions SET token = md5(random()::text || clock_timestamp()::text) || id'

    change_column_null :subscriptions, :token, false
    add_index :subscriptions, :token, unique: true
  end

  def down
    remove_index :subscriptions, :token
    remove_column :subscriptions, :token
  end
end
