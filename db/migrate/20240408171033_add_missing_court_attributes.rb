class AddMissingCourtAttributes < ActiveRecord::Migration
  def change
    add_column :courts, :data_protection_email, :string, null: true
  end
end
