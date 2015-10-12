class FixUniqueIndexOnSources < ActiveRecord::Migration
  def change
    remove_index :sources, column: :module

    add_index :sources, :module, unique: true
  end
end
