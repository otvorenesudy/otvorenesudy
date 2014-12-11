class UpdateApiKeys < ActiveRecord::Migration
  def change
    rename_column :api_keys, :key, :value

    remove_column :api_keys, :updated_at
  end
end
