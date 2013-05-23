class CreateCourtExpenses < ActiveRecord::Migration
  def change
    create_table :court_expenses do |t|
      t.string     :uri,    null: false
      t.references :source, null: false
      t.references :court,  null: false
      t.integer    :year,   null: false
      t.string     :value,  null: false

      t.timestamps
    end

    add_index :court_expenses, :source_id
    add_index :court_expenses, :court_id
  end
end
