class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :model,  null: false
      t.string :digest, null: false
      t.text   :value,  null: false

      t.timestamps
    end

    add_index :queries, [:model, :digest], unique: true
    add_index :queries, [:digest, :model], unique: true
  end
end
