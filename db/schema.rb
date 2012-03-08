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

ActiveRecord::Schema.define(:version => 20120307192500) do

  create_table "milestones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "url_name"
    t.string   "name"
    t.string   "short_description"
    t.string   "description"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_invitations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "status_id"
    t.integer  "priority_id"
    t.integer  "user_id"
    t.date     "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_project_relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "privileges"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "url_name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "email"
    t.string   "name"
    t.string   "about_me"
    t.integer  "privileges"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
