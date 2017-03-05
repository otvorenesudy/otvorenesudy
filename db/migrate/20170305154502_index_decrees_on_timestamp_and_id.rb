class IndexDecreesOnTimestampAndId < ActiveRecord::Migration
  def up
    remove_index :decrees, [:id, :updated_at]
    add_index :decrees, [:updated_at, :id]
  end

  def down
    add_index :decrees, [:id, :updated_at]
    remove_index :decrees, [:updated_at, :id]
  end
end
