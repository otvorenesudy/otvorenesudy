class AddOtherContactsToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :other_contacts_json, :text
  end
end
