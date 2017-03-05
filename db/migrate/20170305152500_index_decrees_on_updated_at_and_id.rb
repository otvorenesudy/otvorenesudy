class IndexDecreesOnUpdatedAtAndId < ActiveRecord::Migration
  def change
    add_index :decrees, [:id, :updated_at]
  end
end
