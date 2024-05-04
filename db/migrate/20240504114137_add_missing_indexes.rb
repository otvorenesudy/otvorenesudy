class AddMissingIndexes < ActiveRecord::Migration
  def up
    remove_index :legislation_areas, :value
    add_index :legislation_areas, :value, unique: true

    remove_index :legislation_subareas, :value
    add_index :legislation_subareas, :value, unique: true

    add_index :judgements, %i[decree_id judge_name_unprocessed], unique: true
  end

  def down
    remove_index :legislation_areas, :value
    add_index :legislation_areas, :value

    remove_index :legislation_subareas, :value
    add_index :legislation_subareas, :value

    remove_index :judgements, %i[decree_id judge_name_unprocessed]
  end
end
