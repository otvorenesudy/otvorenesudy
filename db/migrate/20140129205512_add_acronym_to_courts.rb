class AddAcronymToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :acronym, :string

    add_index :courts, :acronym
  end
end
