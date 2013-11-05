class AddAnonymizedToHearings < ActiveRecord::Migration
  def change
    add_column :hearings, :anonymized, :boolean, default: false
  end
end
