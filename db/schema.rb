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

ActiveRecord::Schema.define(version: 20190805201241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.text     "body"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "namespace",     limit: 255
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "annotation_categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "hex"
    t.string   "css_classes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "author"
    t.datetime "year_published"
    t.string   "edition",             limit: 255
    t.string   "publisher",           limit: 255
    t.string   "source",              limit: 255
    t.string   "rights_status",       limit: 255
    t.string   "slug",                limit: 255
    t.integer  "user_id"
    t.string   "publication_date"
    t.text     "chapters"
    t.string   "state",               limit: 255
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "processed_at"
    t.string   "survey_link",         limit: 255
    t.text     "default_state"
    t.text     "snapshot"
    t.string   "origin"
    t.string   "page_numbers"
    t.string   "series"
    t.string   "location"
    t.string   "journal_title"
    t.text     "notes"
    t.string   "resource_type",                   default: "Other"
    t.index ["slug"], name: "index_documents_on_slug", unique: true, using: :btree
  end

  create_table "documents_groups", id: false, force: :cascade do |t|
    t.integer "document_id", null: false
    t.integer "group_id",    null: false
    t.index ["document_id", "group_id"], name: "index_documents_groups_on_document_id_and_group_id", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string  "name"
    t.integer "owner_id"
    t.boolean "ideaSpaceOn", default: false
    t.index ["name"], name: "index_groups_on_name", unique: true, using: :btree
    t.index ["owner_id"], name: "index_groups_on_owner_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "token"
    t.datetime "expiration_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["group_id"], name: "index_invites_on_group_id", unique: true, using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role",       default: "member"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id", unique: true, using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "redactor_assets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string "name",        limit: 255
    t.string "description", limit: 255
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "tenants", force: :cascade do |t|
    t.string   "domain",                        limit: 255
    t.string   "database_name",                 limit: 255
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "annotation_categories_enabled",             default: false
    t.index ["database_name"], name: "index_tenants_on_database_name", using: :btree
    t.index ["domain"], name: "index_tenants_on_domain", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",              limit: 255, default: "", null: false
    t.string   "lastname",               limit: 255, default: "", null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "affiliation",            limit: 255
    t.string   "slug",                   limit: 255
    t.boolean  "agreement"
    t.string   "provider"
    t.string   "uid"
    t.string   "full_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", using: :btree
  end

  add_foreign_key "groups", "users", column: "owner_id"
end
