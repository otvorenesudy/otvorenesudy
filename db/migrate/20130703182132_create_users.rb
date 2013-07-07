class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # Authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # Confirmable
      t.datetime :confirmed_at
      t.string   :confirmation_token
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Rememberable
      t.datetime :remember_created_at

      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unconfirmed_email,    unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
