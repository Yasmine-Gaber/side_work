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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161017041123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessibility_rules", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accessibility_rules_roles", force: :cascade do |t|
    t.integer "accessibility_rule_id"
    t.integer "role_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "article_countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "daily_target"
    t.integer  "weekly_target"
    t.integer  "monthly_target"
  end

  create_table "article_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "daily_target"
    t.integer  "weekly_target"
    t.integer  "monthly_target"
    t.string   "key"
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "line_manager_id"
    t.integer  "status_id"
    t.datetime "start_date"
    t.datetime "deadline"
    t.datetime "publish_date"
    t.integer  "progress_bar"
    t.integer  "editor_id"
    t.integer  "user_id"
    t.integer  "assignment_id"
    t.string   "drive_link"
    t.integer  "interest_id"
    t.string   "sections_progress_bar"
    t.string   "cms_link"
    t.text     "notes"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "approval_comments"
    t.integer  "approval_status",          default: 0
    t.integer  "sheet_row"
    t.integer  "article_country_id"
    t.string   "article_token"
    t.string   "approval_comments_reply"
    t.integer  "article_type_id"
    t.string   "english_title"
    t.string   "original_link"
    t.string   "initial_title"
    t.text     "suggested_idea"
    t.datetime "incident_date"
    t.integer  "incident_country_id"
    t.text     "processing_point_of_view"
    t.text     "why_publish"
    t.text     "resources"
    t.text     "resources_links"
    t.string   "execution_method"
    t.string   "materials"
    t.string   "final_title"
    t.integer  "translated_words_count"
    t.integer  "original_words_count"
    t.integer  "team_id"
    t.text     "details"
    t.integer  "publisher_id"
    t.integer  "designer_id"
    t.text     "reporter_desk_notes"
    t.text     "trans_desk_notes"
    t.text     "reporter_notes"
    t.text     "manager_notes"
    t.boolean  "publish_flag"
    t.string   "title"
  end

  create_table "articles_personas", force: :cascade do |t|
    t.integer "article_id"
    t.integer "persona_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ar"
    t.string   "alpha3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "daily_target"
    t.integer  "weekly_target"
    t.integer  "monthly_target"
    t.string   "key"
  end

  create_table "message_logs", force: :cascade do |t|
    t.string   "log_type"
    t.string   "description"
    t.integer  "article_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "personas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "daily_target"
    t.integer  "weekly_target"
    t.integer  "monthly_target"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title_ar"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "country_id"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
