class AddSourceReferenceToModels < ActiveRecord::Migration
  def change
    %i[courts judges hearings decrees].each do |table|
      add_column table, :source_class, :string, null: true
      add_column table, :source_class_id, :integer, null: true
      add_index table, %i[source_class source_class_id]
    end
  end
end
