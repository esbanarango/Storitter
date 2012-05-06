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

ActiveRecord::Schema.define(:version => 20120428072538) do

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.text     "message",    :limit => 149,                   :null => false
    t.boolean  "visible",                   :default => true
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id_and_created_at"

  create_table "profiles", :force => true do |t|
    t.string   "username",                     :limit => 40,                    :null => false
    t.string   "first_name",                   :limit => 30
    t.string   "last_name",                    :limit => 30
    t.string   "email",                                                         :null => false
    t.string   "type",                                                          :null => false
    t.string   "fb_uid"
    t.string   "fb_access_token"
    t.boolean  "private",                                    :default => false
    t.boolean  "facebook_autoshare",                         :default => true
    t.string   "function",                     :limit => 40
    t.string   "department",                   :limit => 40
    t.string   "password",                     :limit => 20
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
  end

  create_table "relations", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.boolean  "forbid",       :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "relations", ["follower_id", "following_id"], :name => "index_relations_on_follower_id_and_following_id", :unique => true
  add_index "relations", ["follower_id"], :name => "index_relations_on_follower_id"
  add_index "relations", ["following_id"], :name => "index_relations_on_following_id"

  create_table "sessions", :force => true do |t|
    t.string   "access_token", :null => false
    t.integer  "user_id",      :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "sessions", ["user_id", "access_token"], :name => "index_sessions_on_user_id_and_access_token"

end
