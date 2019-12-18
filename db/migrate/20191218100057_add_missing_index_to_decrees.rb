class AddMissingIndexToDecrees < ActiveRecord::Migration
  def change
    tables = [
      :decrees,
      :hearings,
      :judges,
      :proceedings,
      :selection_procedures,
      :courts
    ]

    tables.each do |table|
      add_index table, :created_at unless index_exists?(table, :created_at)
      add_index table, :updated_at unless index_exists?(table, :updated_at)
    end
  end
end
