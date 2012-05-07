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

ActiveRecord::Schema.define(:version => 20120505013849) do

  create_table "article_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.integer  "comments_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bugs", :force => true do |t|
    t.integer  "project_id"
    t.string   "short_description"
    t.text     "description"
    t.text     "commentary"
    t.integer  "type_id"
    t.integer  "status_id"
    t.integer  "priority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_threads", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "edited_by"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "project_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "url_name"
    t.string   "name"
    t.string   "short_description"
    t.text     "description"
    t.integer  "views"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.integer  "forum_thread_id"
    t.integer  "user_id"
    t.integer  "edited_by"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "team_invitations", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "milestone_id"
    t.string   "name"
    t.text     "description"
    t.integer  "status_id"
    t.integer  "priority_id"
    t.integer  "user_id"
    t.date     "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_configurations", :force => true do |t|
    t.integer "user_id"
    t.integer "language"
    t.integer "contact_privacy_level"
    t.integer "personal_data_privacy_level"
    t.integer "projects_privacy_level"
    t.integer "privileges_privacy_level"
    t.integer "blog_privacy_level"
    t.boolean "widescreen"
  end

  create_table "user_forum_relationships", :force => true do |t|
    t.integer "user_id"
    t.integer "forum_id"
    t.integer "privileges"
  end

  create_table "user_project_relationships", :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "privileges"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "url_name"
    t.string   "name"
    t.string   "surname"
    t.text     "about_me"
    t.string   "email"
    t.string   "www"
    t.integer  "privileges"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
