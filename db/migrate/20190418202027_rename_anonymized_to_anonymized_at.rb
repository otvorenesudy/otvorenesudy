class RenameAnonymizedToAnonymizedAt < ActiveRecord::Migration
  def up
    add_column :hearings, :anonymized_at, :datetime
    add_index :hearings, :anonymized_at

    Hearing.where(anonymized: true).update_all('anonymized_at = updated_at')

    remove_column :hearings, :anonymized
  end

  def down
    add_column :hearings, :anonymized, :boolean
    add_index :hearings, :anonymized

    Hearing.where('hearings.anonymized_at IS NOT NULL').update_all(anonymized: true)

    remove_column :hearings, :anonymized_at
  end
end
