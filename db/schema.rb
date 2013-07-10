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

ActiveRecord::Schema.define(:version => 20130710024231) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "cothread_id"
    t.integer  "link_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["cothread_id"], :name => "index_comments_on_cothread_id"
  add_index "comments", ["link_id"], :name => "index_comments_on_link_id"

  create_table "cothread_translations", :force => true do |t|
    t.integer  "cothread_id"
    t.string   "locale"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cothread_translations", ["cothread_id"], :name => "index_cothread_translations_on_cothread_id"
  add_index "cothread_translations", ["locale"], :name => "index_cothread_translations_on_locale"

  create_table "cothreads", :force => true do |t|
    t.string   "source_locale", :limit => 2
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "link_translations", :force => true do |t|
    t.integer  "link_id"
    t.string   "locale"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "link_translations", ["link_id"], :name => "index_link_translations_on_link_id"
  add_index "link_translations", ["locale"], :name => "index_link_translations_on_locale"

  create_table "links", :force => true do |t|
    t.string   "url",                        :null => false
    t.integer  "user_id"
    t.text     "embed_data"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "source_locale", :limit => 2
  end

  add_index "links", ["url"], :name => "index_links_on_url", :unique => true
  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.text     "profile"
    t.string   "location"
    t.string   "mysite"
    t.string   "fullname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "avatar"
  end

end
