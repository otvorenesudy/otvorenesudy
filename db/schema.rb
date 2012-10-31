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

ActiveRecord::Schema.define(:version => 20121030210430) do

  create_table "accusations", :force => true do |t|
    t.integer  "defendant_id", :null => false
    t.string   "value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "accusations", ["defendant_id"], :name => "index_accusations_on_defendant_id"

  create_table "court_jurisdictions", :force => true do |t|
    t.integer  "court_id",                 :null => false
    t.integer  "court_proceeding_type_id", :null => false
    t.integer  "municipality_id",          :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "court_jurisdictions", ["court_id"], :name => "index_court_jurisdictions_on_court_id"

  create_table "court_offices", :force => true do |t|
    t.integer  "court_id",        :null => false
    t.string   "email"
    t.string   "phone"
    t.string   "hours_monday"
    t.string   "hours_tuesday"
    t.string   "hours_wednesday"
    t.string   "hours_thursday"
    t.string   "hours_friday"
    t.string   "note"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "court_offices", ["court_id"], :name => "index_court_offices_on_court_id"

  create_table "court_proceeding_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_proceeding_types", ["value"], :name => "index_court_proceeding_types_on_value", :unique => true

  create_table "court_types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "court_types", ["value"], :name => "index_court_types_on_value", :unique => true

  create_table "courts", :force => true do |t|
    t.integer  "court_type_id",               :null => false
    t.integer  "municipality_id",             :null => false
    t.string   "name",                        :null => false
    t.string   "street",                      :null => false
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "media_person_name"
    t.string   "media_phone"
    t.integer  "information_center_id"
    t.integer  "registry_center_id"
    t.integer  "business_registry_center_id"
    t.integer  "latitude"
    t.integer  "longitude"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "courts", ["court_type_id"], :name => "index_courts_on_court_type_id"
  add_index "courts", ["municipality_id"], :name => "index_courts_on_municipality_id"
  add_index "courts", ["name"], :name => "index_courts_on_name", :unique => true

  create_table "decree_forms", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "decree_forms", ["value"], :name => "index_decree_forms_on_value", :unique => true

  create_table "decree_natures", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "decree_natures", ["value"], :name => "index_decree_natures_on_value", :unique => true

  create_table "decrees", :force => true do |t|
    t.integer  "proceeding_id"
    t.integer  "court_id",               :null => false
    t.integer  "judge_id",               :null => false
    t.integer  "decree_form_id"
    t.integer  "decree_nature_id"
    t.string   "case_number"
    t.string   "file_number"
    t.date     "date"
    t.string   "ecli"
    t.integer  "legislation_area_id"
    t.integer  "legislation_subarea_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "decrees", ["court_id"], :name => "index_decrees_on_court_id"
  add_index "decrees", ["judge_id"], :name => "index_decrees_on_judge_id"
  add_index "decrees", ["proceeding_id"], :name => "index_decrees_on_proceeding_id"

  create_table "defendants", :force => true do |t|
    t.integer  "hearing_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "defendants", ["hearing_id"], :name => "index_defendants_on_hearing_id"
  add_index "defendants", ["name"], :name => "index_defendants_on_name"

  create_table "employments", :force => true do |t|
    t.integer  "court_id",          :null => false
    t.integer  "judge_id",          :null => false
    t.integer  "judge_position_id", :null => false
    t.boolean  "active",            :null => false
    t.string   "note"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "employments", ["court_id"], :name => "index_employments_on_court_id"
  add_index "employments", ["judge_id"], :name => "index_employments_on_judge_id"

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
    t.integer  "proceeding_id"
    t.integer  "court_id",           :null => false
    t.integer  "hearing_type_id",    :null => false
    t.integer  "hearing_section_id"
    t.integer  "hearing_subject_id"
    t.integer  "hearing_form_id"
    t.string   "case_number"
    t.string   "file_number"
    t.datetime "date"
    t.string   "room"
    t.string   "special_type"
    t.datetime "commencement_date"
    t.integer  "presiding_judge_id"
    t.boolean  "selfjudge"
    t.string   "note"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "hearings", ["court_id"], :name => "index_hearings_on_court_id"
  add_index "hearings", ["proceeding_id"], :name => "index_hearings_on_proceeding_id"

  create_table "judge_positions", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judge_positions", ["value"], :name => "index_judge_positions_on_value", :unique => true

  create_table "judges", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judges", ["name"], :name => "index_judges_on_name", :unique => true

  create_table "judgings", :force => true do |t|
    t.integer  "judge_id",   :null => false
    t.integer  "hearing_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "judgings", ["hearing_id"], :name => "index_judgings_on_hearing_id"
  add_index "judgings", ["judge_id"], :name => "index_judgings_on_judge_id"

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

  add_index "legislation_usages", ["decree_id"], :name => "index_legislation_usages_on_decree_id"
  add_index "legislation_usages", ["legislation_id"], :name => "index_legislation_usages_on_legislation_id"

  create_table "legislations", :force => true do |t|
    t.integer  "number",     :null => false
    t.integer  "year",       :null => false
    t.string   "name",       :null => false
    t.string   "section",    :null => false
    t.string   "paragraph",  :null => false
    t.string   "letter"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "legislations", ["number"], :name => "index_legislations_on_number"

  create_table "municipalities", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "municipalities", ["name"], :name => "index_municipalities_on_name", :unique => true

  create_table "opponents", :force => true do |t|
    t.integer  "hearing_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "opponents", ["hearing_id"], :name => "index_opponents_on_hearing_id"
  add_index "opponents", ["name"], :name => "index_opponents_on_name"

  create_table "proceedings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proposers", :force => true do |t|
    t.integer  "hearing_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "proposers", ["hearing_id"], :name => "index_proposers_on_hearing_id"
  add_index "proposers", ["name"], :name => "index_proposers_on_name"

end
