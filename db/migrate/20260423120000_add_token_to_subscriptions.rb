# frozen_string_literal: true

# The token of each subscription's unsubscribe link, made like Subscription.generate_unique_token makes it.
class AddTokenToSubscriptions < ActiveRecord::Migration[8.1]
  class Subscription < ActiveRecord::Base
    self.table_name = 'subscriptions'
  end

  def up
    add_column :subscriptions, :token, :string, limit: 255

    Subscription.reset_column_information
    Subscription.find_each do |subscription|
      subscription.update_column(:token, SecureRandom.urlsafe_base64(24)) # rubocop:disable Rails/SkipsModelValidations -- a bare model of the table: nothing to skip
    end

    change_column_null :subscriptions, :token, false
    add_index :subscriptions, :token, unique: true
  end

  def down
    remove_index :subscriptions, :token
    remove_column :subscriptions, :token
  end
end
