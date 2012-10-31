class CreateProceedings < ActiveRecord::Migration
  def change
    create_table :proceedings do |t|
      t.timestamps
    end
  end
end
