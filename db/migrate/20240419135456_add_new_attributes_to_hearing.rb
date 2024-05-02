class AddNewAttributesToHearing < ActiveRecord::Migration
  def change
    add_column :hearings, :original_court_id, :integer, null: true
    add_column :hearings, :original_case_number, :string, null: true
  end
end
