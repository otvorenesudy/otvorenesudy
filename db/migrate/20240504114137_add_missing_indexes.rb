class AddMissingIndexes < ActiveRecord::Migration
  def up
    remove_index :legislation_areas, :value
    add_index :legislation_areas, :value, unique: true

    remove_index :legislation_subareas, :value

    subareas = LegislationSubarea.group(:value).having('count(legislation_subareas.value) > 1').pluck(:value)
    subareas.each do |value|
      id, *duplicate_ids = LegislationSubarea.where(value: value).order(:id).pluck(:id)

      values =
        LegislationSubareaUsage
          .where(legislation_subarea_id: duplicate_ids)
          .pluck(:decree_id)
          .map { |decree_id| "(#{decree_id}, #{id}, NOW(), NOW())" }

      ActiveRecord::Base.connection.execute(
        "
          INSERT INTO legislation_subarea_usages (decree_id, legislation_subarea_id, created_at, updated_at)
          VALUES #{values.join(', ')}
          ON CONFLICT (decree_id, legislation_subarea_id)
          DO NOTHING;
        "
      )

      LegislationSubarea.where(id: duplicate_ids).delete_all
    end

    add_index :legislation_subareas, :value, unique: true
  end

  def down
    remove_index :legislation_areas, :value
    add_index :legislation_areas, :value

    remove_index :legislation_subareas, :value
    add_index :legislation_subareas, :value
  end
end
