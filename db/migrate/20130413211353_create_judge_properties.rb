class CreateJudgeProperties < ActiveRecord::Migration
  def change
    create_table :judge_properties do |t|
      t.references :judge_property_list, null: false
      
      t.references :judge_property_acquisition_reason, null: false
      t.references :judge_property_ownership_form,     null: false
      t.references :judge_property_change,             null: false
      
      t.string  :description,      null: false
      t.date    :acquisition_date, null: false
      t.integer :cost,             null: false
      t.string  :share_size
      
      t.timestamps
    end
    
    add_index :judge_properties, :judge_property_list_id
  end
end
