class AllowNonuniqueAndBlankEcliOnDecrees < ActiveRecord::Migration
  def up
    remove_index :decrees, column: :ecli
    add_index :decrees, :ecli

    change_column :decrees, :ecli, :string, null: true
  end

  def down
    remove_index :decree, column: :ecli

    # TODO handle null and duplicated ECLI if needed

    change_column :decrees, :ecli, :string, null: false
    add_index :decrees, :ecli, unique: true
  end
end
