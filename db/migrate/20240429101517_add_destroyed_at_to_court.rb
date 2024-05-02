class AddDestroyedAtToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :destroyed_at, :datetime
  end
end
