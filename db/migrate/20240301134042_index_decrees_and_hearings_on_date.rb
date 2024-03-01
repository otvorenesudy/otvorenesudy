class IndexDecreesAndHearingsOnDate < ActiveRecord::Migration
  def change
    add_index :decrees, :date
    add_index :hearings, :date
  end
end
