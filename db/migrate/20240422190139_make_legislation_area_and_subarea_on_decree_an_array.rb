class MakeLegislationAreaAndSubareaOnDecreeAnArray < ActiveRecord::Migration
  def up
    create_table :legislation_area_usages do |t|
      t.integer :decree_id, null: false
      t.integer :legislation_area_id, null: false
      t.timestamps null: false
    end

    add_index :legislation_area_usages, :decree_id
    add_index :legislation_area_usages, :legislation_area_id
    add_index :legislation_area_usages,
              %i[decree_id legislation_area_id],
              unique: true,
              name: 'index_area_usage_on_decree_id_and_area_id'

    create_table :legislation_subarea_usages do |t|
      t.integer :decree_id, null: false
      t.integer :legislation_subarea_id, null: false
      t.timestamps null: false
    end

    add_index :legislation_subarea_usages, :decree_id
    add_index :legislation_subarea_usages, :legislation_subarea_id
    add_index :legislation_subarea_usages,
              %i[decree_id legislation_subarea_id],
              unique: true,
              name: 'index_subarea_usage_on_decree_id_and_subarea_id'

    Decree
      .select(:id, :legislation_area_id, :legislation_subarea_id)
      .find_in_batches(batch_size: 10_000) do |decree_batch|
        areas = decree_batch.map { |decree| "(#{decree.id}, #{decree.legislation_area_id}, NOW(), NOW())" }
        subareas = decree_batch.map { |decree| "(#{decree.id}, #{decree.legislation_subarea_id}, NOW(), NOW())" }

        ActiveRecord::Base.connection.execute(
          "
            INSERT INTO legislation_area_usages (decree_id, legislation_area_id, created_at, updated_at)
            VALUES #{areas.join(', ')};
          "
        )

        ActiveRecord::Base.connection.execute(
          "
            INSERT INTO legislation_subarea_usages (decree_id, legislation_subarea_id, created_at, updated_at)
            VALUES #{subareas.join(', ')};
          "
        )
      end

    remove_column :decrees, :legislation_area_id
    remove_column :decrees, :legislation_subarea_id
    remove_column :legislation_subarea, :legislation_area
  end

  def down
    # Irreversible
  end
end
