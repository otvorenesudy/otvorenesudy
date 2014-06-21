# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140605144100) do

  create_table "accusations", :force => true do |t|
    t.integer  "defendant_id",                     :null => false
    t.string   "value",             :limit => 510, :null => false
    t.string   "value_unprocessed", :limit => 510, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "accusations", ["defendant_id", "value"], :name => "index_accusations_on_defendant_id_and_value", :unique => true

  create_table "court_expenses", :force => true do |t|
    t.string   "uri",        :null => false
    t.integer  "source_id",  :null => false
    t.integer  "court_id",   :null => false
    t.integer  "year",       :null => false
    t.integer  "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_expenses", ["court_id"], :name => "index_court_expenses_on_court_id"
  add_index "court_expenses", ["source_id"], :name => "index_court_expenses_on_source_id"
  add_index "court_expenses", ["uri"], :name => "index_court_expenses_on_uri"
  add_index "court_expenses", ["year"], :name => "index_court_expenses_on_year"

  create_table "court_jurisdictions", :force => true do |t|
    t.integer  "court_proceeding_type_id", :null => false
    t.integer  "municipality_id",          :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "court_jurisdictions", ["court_proceeding_type_id"], :name => "index_court_jurisdictions_on_court_proceeding_type_id"
  add_index "court_jurisdictions", ["municipality_id"], :name => "index_court_jurisdictions_on_municipality_id"

  create_table "court_office_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_office_types", ["value"], :name => "index_court_office_types_on_value", :unique => true

  create_table "court_offices", :force => true do |t|
    t.integer  "court_id",             :null => false
    t.integer  "court_office_type_id", :null => false
    t.string   "email"
    t.string   "phone"
    t.string   "hours_monday"
    t.string   "hours_tuesday"
    t.string   "hours_wednesday"
    t.string   "hours_thursday"
    t.string   "hours_friday"
    t.text     "note"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "court_offices", ["court_id"], :name => "index_court_offices_on_court_id"

  create_table "court_proceeding_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_proceeding_types", ["value"], :name => "index_court_proceeding_types_on_value", :unique => true

  create_table "court_statistical_summaries", :force => true do |t|
    t.string   "uri",        :null => false
    t.integer  "source_id",  :null => false
    t.integer  "court_id",   :null => false
    t.integer  "year",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_statistical_summaries", ["court_id"], :name => "index_court_statistical_summaries_on_court_id"
  add_index "court_statistical_summaries", ["source_id"], :name => "index_court_statistical_summaries_on_source_id"
  add_index "court_statistical_summaries", ["uri"], :name => "index_court_statistical_summaries_on_uri"
  add_index "court_statistical_summaries", ["year"], :name => "index_court_statistical_summaries_on_year"

  create_table "court_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_types", ["value"], :name => "index_court_types_on_value", :unique => true

  create_table "courts", :force => true do |t|
    t.string   "uri",                                                        :null => false
    t.integer  "source_id",                                                  :null => false
    t.integer  "court_type_id",                                              :null => false
    t.integer  "court_jurisdiction_id"
    t.integer  "municipality_id",                                            :null => false
    t.string   "name",                                                       :null => false
    t.string   "street",                                                     :null => false
    t.string   "phone"
    t.string   "fax"
    t.string   "media_person"
    t.string   "media_person_unprocessed"
    t.string   "media_phone"
    t.integer  "information_center_id"
    t.integer  "registry_center_id"
    t.integer  "business_registry_center_id"
    t.decimal  "latitude",                    :precision => 12, :scale => 8
    t.decimal  "longitude",                   :precision => 12, :scale => 8
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "acronym"
  end

  add_index "courts", ["acronym"], :name => "index_courts_on_acronym"
  add_index "courts", ["court_jurisdiction_id"], :name => "index_courts_on_court_jurisdiction_id"
  add_index "courts", ["court_type_id"], :name => "index_courts_on_court_type_id"
  add_index "courts", ["municipality_id"], :name => "index_courts_on_municipality_id"
  add_index "courts", ["name"], :name => "index_courts_on_name", :unique => true
  add_index "courts", ["source_id"], :name => "index_courts_on_source_id"
  add_index "courts", ["uri"], :name => "index_courts_on_uri", :unique => true

  create_table "decree_forms", :force => true do |t|
    t.string   "value",      :null => false
    t.string   "code",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "decree_forms", ["value"], :name => "index_decree_forms_on_value", :unique => true

  create_table "decree_naturalizations", :force => true do |t|
    t.integer  "decree_id",        :null => false
    t.integer  "decree_nature_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "decree_naturalizations", ["decree_id", "decree_nature_id"], :name => "index_decree_naturalizations_on_decree_id_and_decree_nature_id", :unique => true
  add_index "decree_naturalizations", ["decree_nature_id", "decree_id"], :name => "index_decree_naturalizations_on_decree_nature_id_and_decree_id", :unique => true

  create_table "decree_natures", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "decree_natures", ["value"], :name => "index_decree_natures_on_value", :unique => true

  create_table "decree_pages", :force => true do |t|
    t.integer  "decree_id",  :null => false
    t.integer  "number",     :null => false
    t.text     "text",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "decree_pages", ["decree_id", "number"], :name => "index_decree_pages_on_decree_id_and_number", :unique => true

  create_table "decrees", :force => true do |t|
    t.string   "uri",                    :null => false
    t.integer  "source_id",              :null => false
    t.integer  "proceeding_id"
    t.integer  "court_id"
    t.integer  "decree_form_id"
    t.string   "case_number"
    t.string   "file_number"
    t.date     "date"
    t.string   "ecli"
    t.text     "summary"
    t.integer  "legislation_area_id"
    t.integer  "legislation_subarea_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "decrees", ["case_number"], :name => "index_decrees_on_case_number"
  add_index "decrees", ["court_id"], :name => "index_decrees_on_court_id"
  add_index "decrees", ["decree_form_id"], :name => "index_decrees_on_decree_form_id"
  add_index "decrees", ["file_number"], :name => "index_decrees_on_file_number"
  add_index "decrees", ["proceeding_id"], :name => "index_decrees_on_proceeding_id"
  add_index "decrees", ["source_id"], :name => "index_decrees_on_source_id"
  add_index "decrees", ["uri"], :name => "index_decrees_on_uri", :unique => true

  create_table "defendants", :force => true do |t|
    t.integer  "hearing_id",       :null => false
    t.string   "name",             :null => false
    t.string   "name_unprocessed", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "defendants", ["hearing_id", "name"], :name => "index_defendants_on_hearing_id_and_name", :unique => true
  add_index "defendants", ["name"], :name => "index_defendants_on_name"
  add_index "defendants", ["name_unprocessed"], :name => "index_defendants_on_name_unprocessed"

  create_table "employments", :force => true do |t|
    t.integer  "court_id",          :null => false
    t.integer  "judge_id",          :null => false
    t.integer  "judge_position_id"
    t.boolean  "active"
    t.text     "note"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "employments", ["active"], :name => "index_employments_on_active"
  add_index "employments", ["court_id", "judge_id"], :name => "index_employments_on_court_id_and_judge_id"
  add_index "employments", ["judge_id", "court_id"], :name => "index_employments_on_judge_id_and_court_id"

  create_table "hearing_forms", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hearing_forms", ["value"], :name => "index_hearing_forms_on_value", :unique => true

  create_table "hearing_sections", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hearing_sections", ["value"], :name => "index_hearing_sections_on_value", :unique => true

  create_table "hearing_subjects", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hearing_subjects", ["value"], :name => "index_hearing_subjects_on_value", :unique => true

  create_table "hearing_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hearing_types", ["value"], :name => "index_hearing_types_on_value", :unique => true

  create_table "hearings", :force => true do |t|
    t.string   "uri",                                   :null => false
    t.integer  "source_id",                             :null => false
    t.integer  "proceeding_id"
    t.integer  "court_id"
    t.integer  "hearing_type_id",                       :null => false
    t.integer  "hearing_section_id"
    t.integer  "hearing_subject_id"
    t.integer  "hearing_form_id"
    t.string   "case_number"
    t.string   "file_number"
    t.datetime "date"
    t.string   "room"
    t.string   "special_type"
    t.datetime "commencement_date"
    t.boolean  "selfjudge"
    t.text     "note"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "anonymized",         :default => false
  end

  add_index "hearings", ["case_number"], :name => "index_hearings_on_case_number"
  add_index "hearings", ["court_id"], :name => "index_hearings_on_court_id"
  add_index "hearings", ["file_number"], :name => "index_hearings_on_file_number"
  add_index "hearings", ["proceeding_id"], :name => "index_hearings_on_proceeding_id"
  add_index "hearings", ["source_id"], :name => "index_hearings_on_source_id"
  add_index "hearings", ["uri"], :name => "index_hearings_on_uri", :unique => true

  create_table "judge_designation_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_designation_types", ["value"], :name => "index_judge_designation_types_on_value", :unique => true

  create_table "judge_designations", :force => true do |t|
    t.string   "uri",                       :null => false
    t.integer  "source_id",                 :null => false
    t.integer  "judge_id",                  :null => false
    t.integer  "judge_designation_type_id"
    t.date     "date",                      :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "judge_designations", ["date"], :name => "index_judge_designations_on_date"
  add_index "judge_designations", ["judge_designation_type_id"], :name => "index_judge_designations_on_judge_designation_type_id"
  add_index "judge_designations", ["judge_id"], :name => "index_judge_designations_on_judge_id"
  add_index "judge_designations", ["source_id"], :name => "index_judge_designations_on_source_id"
  add_index "judge_designations", ["uri"], :name => "index_judge_designations_on_uri"

  create_table "judge_incomes", :force => true do |t|
    t.integer  "judge_property_declaration_id",                                :null => false
    t.string   "description",                                                  :null => false
    t.decimal  "value",                         :precision => 12, :scale => 2, :null => false
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "judge_incomes", ["description"], :name => "index_judge_incomes_on_description"
  add_index "judge_incomes", ["judge_property_declaration_id", "description"], :name => "index_judge_incomes_on_unique_values", :unique => true

  create_table "judge_positions", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_positions", ["value"], :name => "index_judge_positions_on_value", :unique => true

  create_table "judge_proclaims", :force => true do |t|
    t.integer  "judge_property_declaration_id", :null => false
    t.integer  "judge_statement_id",            :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "judge_proclaims", ["judge_property_declaration_id", "judge_statement_id"], :name => "index_judge_proclaims_on_unique_values", :unique => true
  add_index "judge_proclaims", ["judge_statement_id", "judge_property_declaration_id"], :name => "index_judge_proclaims_on_unique_values_reversed", :unique => true

  create_table "judge_properties", :force => true do |t|
    t.integer  "judge_property_list_id",               :null => false
    t.integer  "judge_property_acquisition_reason_id"
    t.integer  "judge_property_ownership_form_id"
    t.integer  "judge_property_change_id"
    t.string   "description"
    t.string   "acquisition_date"
    t.integer  "cost"
    t.string   "share_size"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "judge_properties", ["judge_property_list_id"], :name => "index_judge_properties_on_judge_property_list_id"

  create_table "judge_property_acquisition_reasons", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_property_acquisition_reasons", ["value"], :name => "index_judge_property_acquisition_reasons_on_value", :unique => true

  create_table "judge_property_categories", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_property_categories", ["value"], :name => "index_judge_property_categories_on_value", :unique => true

  create_table "judge_property_changes", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_property_changes", ["value"], :name => "index_judge_property_changes_on_value", :unique => true

  create_table "judge_property_declarations", :force => true do |t|
    t.string   "uri",        :null => false
    t.integer  "source_id",  :null => false
    t.integer  "court_id",   :null => false
    t.integer  "judge_id",   :null => false
    t.integer  "year",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_property_declarations", ["court_id"], :name => "index_judge_property_declarations_on_court_id"
  add_index "judge_property_declarations", ["judge_id", "year"], :name => "index_judge_property_declarations_on_judge_id_and_year", :unique => true
  add_index "judge_property_declarations", ["source_id"], :name => "index_judge_property_declarations_on_source_id"
  add_index "judge_property_declarations", ["uri"], :name => "index_judge_property_declarations_on_uri", :unique => true
  add_index "judge_property_declarations", ["year", "judge_id"], :name => "index_judge_property_declarations_on_year_and_judge_id", :unique => true

  create_table "judge_property_lists", :force => true do |t|
    t.integer  "judge_property_declaration_id", :null => false
    t.integer  "judge_property_category_id",    :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "judge_property_lists", ["judge_property_category_id", "judge_property_declaration_id"], :name => "index_judge_property_lists_on_unique_values_reversed", :unique => true
  add_index "judge_property_lists", ["judge_property_declaration_id", "judge_property_category_id"], :name => "index_judge_property_lists_on_unique_values", :unique => true

  create_table "judge_property_ownership_forms", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_property_ownership_forms", ["value"], :name => "index_judge_property_ownership_forms_on_value", :unique => true

  create_table "judge_related_people", :force => true do |t|
    t.integer  "judge_property_declaration_id", :null => false
    t.string   "name",                          :null => false
    t.string   "name_unprocessed",              :null => false
    t.string   "institution"
    t.string   "function"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "judge_related_people", ["function"], :name => "index_judge_related_people_on_function"
  add_index "judge_related_people", ["institution"], :name => "index_judge_related_people_on_institution"
  add_index "judge_related_people", ["judge_property_declaration_id", "name"], :name => "index_judge_related_people_on_unique_values", :unique => true
  add_index "judge_related_people", ["name"], :name => "index_judge_related_people_on_name"

  create_table "judge_senate_inclusions", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_senate_inclusions", ["value"], :name => "index_judge_senate_inclusions_on_value", :unique => true

  create_table "judge_statements", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_statements", ["value"], :name => "index_judge_statements_on_value", :unique => true

  create_table "judge_statistical_summaries", :force => true do |t|
    t.string   "uri",                             :null => false
    t.integer  "source_id",                       :null => false
    t.integer  "court_id",                        :null => false
    t.integer  "judge_id",                        :null => false
    t.integer  "judge_senate_inclusion_id"
    t.string   "author"
    t.integer  "year",                            :null => false
    t.date     "date"
    t.integer  "days_worked"
    t.integer  "days_heard"
    t.integer  "days_used"
    t.integer  "released_constitutional_decrees"
    t.integer  "delayed_constitutional_decrees"
    t.text     "idea_reduction_reasons"
    t.text     "educational_activities"
    t.text     "substantiation_notes"
    t.text     "court_chair_actions"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "judge_statistical_summaries", ["author"], :name => "index_judge_statistical_summaries_on_author"
  add_index "judge_statistical_summaries", ["court_id"], :name => "index_judge_statistical_summaries_on_court_id"
  add_index "judge_statistical_summaries", ["date"], :name => "index_judge_statistical_summaries_on_date"
  add_index "judge_statistical_summaries", ["judge_id"], :name => "index_judge_statistical_summaries_on_judge_id"
  add_index "judge_statistical_summaries", ["source_id"], :name => "index_judge_statistical_summaries_on_source_id"
  add_index "judge_statistical_summaries", ["uri"], :name => "index_judge_statistical_summaries_on_uri"
  add_index "judge_statistical_summaries", ["year"], :name => "index_judge_statistical_summaries_on_year"

  create_table "judgements", :force => true do |t|
    t.integer  "decree_id",                                            :null => false
    t.integer  "judge_id",                                             :null => false
    t.decimal  "judge_name_similarity",  :precision => 3, :scale => 2, :null => false
    t.string   "judge_name_unprocessed",                               :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "judgements", ["decree_id", "judge_id"], :name => "index_judgements_on_decree_id_and_judge_id", :unique => true
  add_index "judgements", ["judge_id", "decree_id"], :name => "index_judgements_on_judge_id_and_decree_id", :unique => true
  add_index "judgements", ["judge_name_unprocessed"], :name => "index_judgements_on_judge_name_unprocessed"

  create_table "judges", :force => true do |t|
    t.string   "uri",              :null => false
    t.integer  "source_id",        :null => false
    t.string   "name",             :null => false
    t.string   "name_unprocessed", :null => false
    t.string   "prefix"
    t.string   "first",            :null => false
    t.string   "middle"
    t.string   "last",             :null => false
    t.string   "suffix"
    t.string   "addition"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "judges", ["first", "middle", "last"], :name => "index_judges_on_first_and_middle_and_last"
  add_index "judges", ["last", "middle", "first"], :name => "index_judges_on_last_and_middle_and_first"
  add_index "judges", ["name"], :name => "index_judges_on_name", :unique => true
  add_index "judges", ["name_unprocessed"], :name => "index_judges_on_name_unprocessed", :unique => true
  add_index "judges", ["source_id"], :name => "index_judges_on_source_id"
  add_index "judges", ["uri"], :name => "index_judges_on_uri"

  create_table "judgings", :force => true do |t|
    t.integer  "hearing_id",                                           :null => false
    t.integer  "judge_id",                                             :null => false
    t.decimal  "judge_name_similarity",  :precision => 3, :scale => 2, :null => false
    t.string   "judge_name_unprocessed",                               :null => false
    t.boolean  "judge_chair",                                          :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "judgings", ["hearing_id", "judge_id"], :name => "index_judgings_on_hearing_id_and_judge_id", :unique => true
  add_index "judgings", ["judge_id", "hearing_id"], :name => "index_judgings_on_judge_id_and_hearing_id", :unique => true
  add_index "judgings", ["judge_name_unprocessed"], :name => "index_judgings_on_judge_name_unprocessed"

  create_table "legislation_areas", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "legislation_areas", ["value"], :name => "index_legislation_areas_on_value"

  create_table "legislation_subareas", :force => true do |t|
    t.integer  "legislation_area_id", :null => false
    t.string   "value",               :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "legislation_subareas", ["legislation_area_id"], :name => "index_legislation_subareas_on_legislation_area_id"
  add_index "legislation_subareas", ["value"], :name => "index_legislation_subareas_on_value"

  create_table "legislation_usages", :force => true do |t|
    t.integer  "legislation_id", :null => false
    t.integer  "decree_id",      :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "legislation_usages", ["decree_id", "legislation_id"], :name => "index_legislation_usages_on_decree_id_and_legislation_id", :unique => true
  add_index "legislation_usages", ["legislation_id", "decree_id"], :name => "index_legislation_usages_on_legislation_id_and_decree_id", :unique => true

  create_table "legislations", :force => true do |t|
    t.string   "value",             :limit => 510, :null => false
    t.string   "value_unprocessed", :limit => 510, :null => false
    t.string   "type"
    t.integer  "number"
    t.integer  "year"
    t.string   "name",              :limit => 510
    t.string   "section"
    t.string   "paragraph"
    t.string   "letter"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "legislations", ["value"], :name => "index_legislations_on_value", :unique => true

  create_table "municipalities", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "zipcode",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "municipalities", ["name"], :name => "index_municipalities_on_name", :unique => true
  add_index "municipalities", ["zipcode"], :name => "index_municipalities_on_zipcode"

  create_table "opponents", :force => true do |t|
    t.integer  "hearing_id",       :null => false
    t.string   "name",             :null => false
    t.string   "name_unprocessed", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "opponents", ["hearing_id", "name"], :name => "index_opponents_on_hearing_id_and_name", :unique => true
  add_index "opponents", ["name"], :name => "index_opponents_on_name"
  add_index "opponents", ["name_unprocessed"], :name => "index_opponents_on_name_unprocessed"

  create_table "paragraph_explanations", :force => true do |t|
    t.integer  "paragraph_id",     :null => false
    t.integer  "explainable_id",   :null => false
    t.string   "explainable_type", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "paragraph_explanations", ["explainable_id", "explainable_type", "paragraph_id"], :name => "index_paragraph_explainations_on_unique_values_reversed", :unique => true
  add_index "paragraph_explanations", ["paragraph_id", "explainable_id", "explainable_type"], :name => "index_paragraph_explainations_on_unique_values", :unique => true

  create_table "paragraphs", :force => true do |t|
    t.integer  "legislation", :null => false
    t.string   "number",      :null => false
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "paragraphs", ["legislation", "number"], :name => "index_paragraphs_on_legislation_and_number", :unique => true

  create_table "periods", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "periods", ["name"], :name => "index_periods_on_name", :unique => true

  create_table "proceedings", :force => true do |t|
    t.string   "file_number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "proceedings", ["file_number"], :name => "index_proceedings_on_file_number", :unique => true

  create_table "proposers", :force => true do |t|
    t.integer  "hearing_id",       :null => false
    t.string   "name",             :null => false
    t.string   "name_unprocessed", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "proposers", ["hearing_id", "name"], :name => "index_proposers_on_hearing_id_and_name", :unique => true
  add_index "proposers", ["name"], :name => "index_proposers_on_name"
  add_index "proposers", ["name_unprocessed"], :name => "index_proposers_on_name_unprocessed"

  create_table "queries", :force => true do |t|
    t.string   "model",      :null => false
    t.string   "digest",     :null => false
    t.text     "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "queries", ["digest", "model"], :name => "index_queries_on_digest_and_model", :unique => true
  add_index "queries", ["model", "digest"], :name => "index_queries_on_model_and_digest", :unique => true

  create_table "selection_procedure_candidates", :force => true do |t|
    t.string   "uri"
    t.integer  "selection_procedure_id",    :null => false
    t.integer  "judge_id"
    t.string   "name",                      :null => false
    t.string   "name_unprocessed",          :null => false
    t.text     "accomplished_expectations"
    t.string   "oral_score"
    t.string   "oral_result"
    t.string   "written_score"
    t.string   "written_result"
    t.string   "score"
    t.string   "position"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "selection_procedure_candidates", ["judge_id"], :name => "index_selection_procedure_candidates_on_judge_id"
  add_index "selection_procedure_candidates", ["name"], :name => "index_selection_procedure_candidates_on_name"
  add_index "selection_procedure_candidates", ["name_unprocessed"], :name => "index_selection_procedure_candidates_on_name_unprocessed"
  add_index "selection_procedure_candidates", ["selection_procedure_id"], :name => "index_selection_procedure_candidates_on_selection_procedure_id"

  create_table "selection_procedure_commissioners", :force => true do |t|
    t.integer  "selection_procedure_id", :null => false
    t.integer  "judge_id"
    t.string   "name",                   :null => false
    t.string   "name_unprocessed",       :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "selection_procedure_commissioners", ["judge_id"], :name => "index_selection_procedure_commissioners_on_judge_id"
  add_index "selection_procedure_commissioners", ["name"], :name => "index_selection_procedure_commissioners_on_name"
  add_index "selection_procedure_commissioners", ["name_unprocessed"], :name => "index_selection_procedure_commissioners_on_name_unprocessed"
  add_index "selection_procedure_commissioners", ["selection_procedure_id"], :name => "index_commissioners_on_selection_procedure"

  create_table "selection_procedures", :force => true do |t|
    t.string   "uri",                           :null => false
    t.integer  "source_id",                     :null => false
    t.integer  "court_id"
    t.string   "organization_name",             :null => false
    t.string   "organization_name_unprocessed", :null => false
    t.text     "organization_description"
    t.date     "date"
    t.text     "description"
    t.string   "place"
    t.string   "position",                      :null => false
    t.string   "state"
    t.string   "workplace"
    t.datetime "closed_at",                     :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "selection_procedures", ["closed_at"], :name => "index_selection_procedures_on_closed_at"
  add_index "selection_procedures", ["court_id"], :name => "index_selection_procedures_on_court_id"
  add_index "selection_procedures", ["date"], :name => "index_selection_procedures_on_date"
  add_index "selection_procedures", ["organization_name"], :name => "index_selection_procedures_on_organization_name"
  add_index "selection_procedures", ["organization_name_unprocessed"], :name => "index_selection_procedures_on_organization_name_unprocessed"
  add_index "selection_procedures", ["source_id"], :name => "index_selection_procedures_on_source_id"
  add_index "selection_procedures", ["uri"], :name => "index_selection_procedures_on_uri"

  create_table "sources", :force => true do |t|
    t.string   "module",     :null => false
    t.string   "name",       :null => false
    t.string   "uri",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sources", ["module"], :name => "index_sources_on_module", :unique => true
  add_index "sources", ["name"], :name => "index_sources_on_name", :unique => true
  add_index "sources", ["uri"], :name => "index_sources_on_uri", :unique => true

  create_table "statistical_table_cells", :force => true do |t|
    t.integer  "statistical_table_column_id", :null => false
    t.integer  "statistical_table_row_id",    :null => false
    t.string   "value"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "statistical_table_cells", ["statistical_table_column_id", "statistical_table_row_id"], :name => "index_statistical_table_cells_on_unique_values", :unique => true
  add_index "statistical_table_cells", ["statistical_table_row_id", "statistical_table_column_id"], :name => "index_statistical_table_cells_on_unique_values_reversed", :unique => true

  create_table "statistical_table_column_names", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statistical_table_column_names", ["value"], :name => "index_statistical_table_column_names_on_value", :unique => true

  create_table "statistical_table_columns", :force => true do |t|
    t.integer  "statistical_table_id",             :null => false
    t.integer  "statistical_table_column_name_id", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "statistical_table_columns", ["statistical_table_id", "statistical_table_column_name_id"], :name => "index_statistical_table_columns_on_unique_values", :unique => true

  create_table "statistical_table_names", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statistical_table_names", ["value"], :name => "index_statistical_table_names_on_value", :unique => true

  create_table "statistical_table_row_names", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statistical_table_row_names", ["value"], :name => "index_statistical_table_row_names_on_value", :unique => true

  create_table "statistical_table_rows", :force => true do |t|
    t.integer  "statistical_table_id",          :null => false
    t.integer  "statistical_table_row_name_id", :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "statistical_table_rows", ["statistical_table_id", "statistical_table_row_name_id"], :name => "index_statistical_table_rows_on_unique_values", :unique => true

  create_table "statistical_tables", :force => true do |t|
    t.integer  "statistical_summary_id",    :null => false
    t.string   "statistical_summary_type",  :null => false
    t.integer  "statistical_table_name_id", :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "statistical_tables", ["statistical_summary_id", "statistical_summary_type", "statistical_table_name_id"], :name => "index_statistical_tables_on_summary_and_name", :unique => true
  add_index "statistical_tables", ["statistical_table_name_id"], :name => "index_statistical_tables_on_statistical_table_name_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "query_id",   :null => false
    t.integer  "period_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subscriptions", ["period_id"], :name => "index_subscriptions_on_period_id"
  add_index "subscriptions", ["query_id"], :name => "index_subscriptions_on_query_id"
  add_index "subscriptions", ["user_id", "query_id", "period_id"], :name => "index_subscriptions_on_user_id_and_query_id_and_period_id", :unique => true
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.datetime "confirmed_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unconfirmed_email"], :name => "index_users_on_unconfirmed_email", :unique => true

end
