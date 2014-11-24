class AllowLongerUrisAndUrls < ActiveRecord::Migration
  def change
    change_column :sources, :uri, :string, limit: 2048

    change_column :courts,   :uri, :string, limit: 2048
    change_column :judges,   :uri, :string, limit: 2048
    change_column :hearings, :uri, :string, limit: 2048
    change_column :decrees,  :uri, :string, limit: 2048

    change_column :judge_statistical_summaries, :uri, :string, limit: 2048
    change_column :judge_property_declarations, :uri, :string, limit: 2048
    change_column :judge_designations,          :uri, :string, limit: 2048

    change_column :court_statistical_summaries, :uri, :string, limit: 2048
    change_column :court_expenses,              :uri, :string, limit: 2048

    change_column :selection_procedures, :uri, :string, limit: 2048

    change_column :selection_procedures, :declaration_url, :string, limit: 2048
    change_column :selection_procedures, :report_url,      :string, limit: 2048

    change_column :selection_procedure_candidates, :application_url,       :string, limit: 2048
    change_column :selection_procedure_candidates, :curriculum_url,        :string, limit: 2048
    change_column :selection_procedure_candidates, :declaration_url,       :string, limit: 2048
    change_column :selection_procedure_candidates, :motivation_letter_url, :string, limit: 2048
  end
end
