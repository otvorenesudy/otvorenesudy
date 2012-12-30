# TODO rm?

class AddGinIndexToCourtName < ActiveRecord::Migration
  def up
    add_index :courts, :name, gin: true, name: 'gin_index_courts_on_name' 
  end

  def down
    remove_index :courts, name: 'gin_index_courts_on_name'
  end
end
