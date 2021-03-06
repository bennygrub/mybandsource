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

ActiveRecord::Schema.define(version: 20171013065244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "picture",     default: ""
    t.integer  "user_id"
    t.index ["name"], name: "index_genres_on_name", unique: true, using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "generating_user_id",                      null: false
    t.integer  "receiving_user_id",                       null: false
    t.integer  "review_id"
    t.integer  "response_id"
    t.string   "notification_type"
    t.boolean  "viewed",                  default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "generating_user_name",                    null: false
    t.string   "generating_user_picture"
    t.index ["generating_user_id"], name: "index_notifications_on_generating_user_id", using: :btree
    t.index ["receiving_user_id"], name: "index_notifications_on_receiving_user_id", using: :btree
    t.index ["response_id"], name: "index_notifications_on_response_id", using: :btree
    t.index ["review_id"], name: "index_notifications_on_review_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "upvotes",          default: 0
    t.text     "upvotes_userlist", default: [],                 array: true
    t.text     "comment",                          null: false
    t.integer  "user_id",                          null: false
    t.integer  "review_id",                        null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "reported",         default: false
    t.index ["review_id"], name: "index_responses_on_review_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "comment"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "rating",            default: -1
    t.integer  "upvotes",           default: 0
    t.text     "upvotes_userlist",  default: [],                 array: true
    t.integer  "receiving_user_id",                 null: false
    t.integer  "leaving_user_id",                   null: false
    t.boolean  "reported",          default: false
    t.index ["leaving_user_id"], name: "index_reviews_on_leaving_user_id", using: :btree
    t.index ["receiving_user_id"], name: "index_reviews_on_receiving_user_id", using: :btree
  end

  create_table "user_relationships", force: :cascade do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_user_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_user_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_user_relationships_on_follower_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name",                   default: "",  null: false
    t.string   "location"
    t.string   "picture"
    t.text     "bio",                    default: ""
    t.string   "provider"
    t.string   "uid"
    t.boolean  "is_artist"
    t.string   "real_name"
    t.string   "data_quality"
    t.string   "facebook_url"
    t.string   "soundcloud_url"
    t.string   "spotify_url"
    t.string   "itunes_url"
    t.string   "twitter_url"
    t.integer  "genre_id"
    t.string   "banner_picture"
    t.string   "label"
    t.float    "average_rating",         default: 0.0
    t.integer  "review_count",           default: 0
    t.integer  "response_count",         default: 0
    t.text     "genres_list",            default: [],               array: true
    t.boolean  "featured"
    t.integer  "view_count",             default: 0
    t.string   "slug"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["featured"], name: "index_users_on_featured", using: :btree
    t.index ["genre_id"], name: "index_users_on_genre_id", using: :btree
    t.index ["location"], name: "index_users_on_location", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "genres", "users"
  add_foreign_key "notifications", "responses"
  add_foreign_key "notifications", "reviews"
  add_foreign_key "notifications", "users", column: "generating_user_id"
  add_foreign_key "notifications", "users", column: "receiving_user_id"
  add_foreign_key "responses", "reviews"
  add_foreign_key "responses", "users"
  add_foreign_key "reviews", "users", column: "leaving_user_id"
  add_foreign_key "reviews", "users", column: "receiving_user_id"
  add_foreign_key "user_relationships", "users", column: "followed_id"
  add_foreign_key "user_relationships", "users", column: "follower_id"
  add_foreign_key "users", "genres"
end
