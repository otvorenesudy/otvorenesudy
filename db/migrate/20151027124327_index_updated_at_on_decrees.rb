class IndexUpdatedAtOnDecrees < ActiveRecord::Migration
  def up
    add_index :decrees, :updated_at
  end

  def down
    remove_index :decrees, column: :updated_at
  end
end
