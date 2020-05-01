class AddStatusToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :status, :string, null: true
  end
end
