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

ActiveRecord::Schema.define(version: 20160130143145) do

  create_table "core_accounts", force: :cascade do |t|
    t.string   "company_name",     limit: 255
    t.string   "contact_email",    limit: 255
    t.string   "domain",           limit: 255
    t.string   "account_prefix",   limit: 255
    t.integer  "default_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "next_invoice_num",             default: 1000
  end

  create_table "core_activities", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "browser",    limit: 255
    t.string   "session_id", limit: 255
    t.string   "ip_address", limit: 255
    t.string   "controller", limit: 255
    t.string   "action",     limit: 255
    t.string   "params",     limit: 255
    t.string   "slug",       limit: 255
    t.string   "lesson",     limit: 255
    t.datetime "created_at"
  end

  add_index "core_activities", ["account_id"], name: "index_core_activities_on_account_id"
  add_index "core_activities", ["user_id"], name: "index_core_activities_on_user_id"

  create_table "core_addresses", force: :cascade do |t|
    t.string   "line1",            limit: 255
    t.string   "line2",            limit: 255
    t.string   "city",             limit: 255
    t.string   "state",            limit: 255
    t.string   "zip",              limit: 255
    t.string   "country_code",     limit: 2
    t.integer  "addressable_id"
    t.string   "addressable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_addresses", ["addressable_type", "addressable_id"], name: "index_core_addresses_on_addressable_type_and_addressable_id", unique: true

  create_table "core_categories", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.integer  "row_order"
    t.integer  "account_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "core_category_translations", force: :cascade do |t|
    t.integer  "core_category_id"
    t.string   "locale",           limit: 255
    t.string   "name",             limit: 255
    t.string   "description",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_category_translations", ["core_category_id"], name: "index_category_translation"

  create_table "core_comments", force: :cascade do |t|
    t.string   "title",            limit: 50,  default: ""
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.integer  "user_id"
    t.string   "role",             limit: 255, default: "comments"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",             limit: 255
    t.string   "ancestry",         limit: 255
    t.integer  "ancestry_depth",               default: 0
  end

  add_index "core_comments", ["commentable_id"], name: "index_core_comments_on_commentable_id"
  add_index "core_comments", ["commentable_type"], name: "index_core_comments_on_commentable_type"
  add_index "core_comments", ["user_id"], name: "index_core_comments_on_user_id"

  create_table "core_custom_field_def_translations", force: :cascade do |t|
    t.integer  "core_custom_field_def_id"
    t.string   "locale",                   limit: 255
    t.string   "label",                    limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_custom_field_def_translations", ["core_custom_field_def_id"], name: "core_custom_field_def_translations_index"

  create_table "core_custom_field_defs", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 255
    t.string   "name",       limit: 255
    t.string   "field_type", limit: 255
    t.integer  "row_order"
    t.boolean  "required",                default: false
    t.string   "properties", limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "core_custom_field_defs", ["account_id"], name: "index_core_custom_field_defs_on_account_id"
  add_index "core_custom_field_defs", ["owner_id", "owner_type"], name: "index_core_custom_field_defs_on_owner_id_and_owner_type"

  create_table "core_custom_fields", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type",          limit: 255
    t.integer  "custom_field_def_id"
    t.string   "field_data",          limit: 4096
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "core_custom_fields", ["account_id"], name: "index_core_custom_fields_on_account_id"
  add_index "core_custom_fields", ["owner_id", "owner_type"], name: "index_core_custom_fields_on_owner_id_and_owner_type"

  create_table "core_payment_histories", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type",      limit: 30
    t.string   "anchor_id",       limit: 20
    t.string   "order_ref",       limit: 255
    t.string   "item_ref",        limit: 255
    t.string   "item_name",       limit: 255
    t.integer  "quantity"
    t.string   "cost",            limit: 255
    t.string   "discount",        limit: 255
    t.integer  "total_cents"
    t.string   "total_currency",  limit: 3
    t.string   "payment_method",  limit: 255
    t.datetime "payment_date"
    t.string   "bill_to_name",    limit: 255
    t.text     "item_details"
    t.text     "order_details"
    t.string   "status",          limit: 255
    t.integer  "user_profile_id"
    t.datetime "created_on"
    t.integer  "account_id"
    t.text     "notify_data"
    t.string   "transaction_id",  limit: 255
  end

  add_index "core_payment_histories", ["anchor_id"], name: "index_payment_histories_on_anchor_id"
  add_index "core_payment_histories", ["item_ref"], name: "index_payment_histories_on_item_ref"
  add_index "core_payment_histories", ["order_ref"], name: "index_payment_histories_on_order_ref"
  add_index "core_payment_histories", ["owner_id"], name: "index_payment_histories_on_owner_id"
  add_index "core_payment_histories", ["owner_type"], name: "index_payment_histories_on_owner_type"

  create_table "core_system_email_translations", force: :cascade do |t|
    t.integer  "core_system_email_id"
    t.string   "locale",               limit: 255
    t.string   "subject",              limit: 255
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_system_emails", force: :cascade do |t|
    t.string   "email_type",     limit: 255
    t.integer  "emailable_id"
    t.string   "emailable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                               null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",                                 null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "globalize_countries", force: :cascade do |t|
    t.string "code",                   limit: 2
    t.string "english_name",           limit: 255
    t.string "date_format",            limit: 255
    t.string "currency_format",        limit: 255
    t.string "currency_code",          limit: 3
    t.string "thousands_sep",          limit: 2
    t.string "decimal_sep",            limit: 2
    t.string "currency_decimal_sep",   limit: 2
    t.string "number_grouping_scheme", limit: 255
    t.string "continent",              limit: 255
    t.string "locale",                 limit: 255
  end

  add_index "globalize_countries", ["code"], name: "index_globalize_countries_on_code"
  add_index "globalize_countries", ["locale"], name: "index_globalize_countries_on_locale"

  create_table "globalize_languages", force: :cascade do |t|
    t.string  "iso_639_1",             limit: 2
    t.string  "iso_639_2",             limit: 3
    t.string  "iso_639_3",             limit: 3
    t.string  "rfc_3066",              limit: 255
    t.string  "english_name",          limit: 255
    t.string  "english_name_locale",   limit: 255
    t.string  "english_name_modifier", limit: 255
    t.string  "native_name",           limit: 255
    t.string  "native_name_locale",    limit: 255
    t.string  "native_name_modifier",  limit: 255
    t.boolean "macro_language"
    t.string  "direction",             limit: 255
    t.string  "pluralization",         limit: 255
    t.string  "scope",                 limit: 1
  end

  add_index "globalize_languages", ["iso_639_1"], name: "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], name: "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], name: "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], name: "index_globalize_languages_on_rfc_3066"

  create_table "knw_document_media_file_translations", force: :cascade do |t|
    t.integer  "knw_document_media_file_id"
    t.string   "locale"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "knw_document_media_files", force: :cascade do |t|
    t.string   "media"
    t.integer  "media_file_size"
    t.string   "media_content_type"
    t.string   "category"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "knw_documents", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "content"
    t.text     "summary"
    t.datetime "original_date"
    t.boolean  "published"
    t.boolean  "is_public"
    t.boolean  "requires_login"
    t.datetime "updated_on"
    t.datetime "created_on"
    t.integer  "account_id"
    t.integer  "lock_version",   default: 0, null: false
    t.string   "slug"
    t.text     "notes"
  end

  create_table "preferences", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "owner_id",               null: false
    t.string   "owner_type", limit: 255, null: false
    t.integer  "group_id"
    t.string   "group_type", limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], name: "index_preferences_on_owner_and_name_and_preference", unique: true

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id"
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "roles", ["account_id"], name: "index_roles_on_account_id"
  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "public_name",                   limit: 50,  default: ""
    t.string   "first_name",                    limit: 50,  default: ""
    t.string   "last_name",                     limit: 50,  default: ""
    t.string   "address",                       limit: 70,  default: ""
    t.string   "address2",                      limit: 70,  default: ""
    t.string   "city",                          limit: 30,  default: ""
    t.string   "state",                         limit: 30,  default: ""
    t.string   "zipcode",                       limit: 10,  default: ""
    t.integer  "country_id",                                default: 0
    t.string   "phone",                         limit: 20,  default: ""
    t.string   "cell",                          limit: 20,  default: ""
    t.string   "fax",                           limit: 20,  default: ""
    t.string   "workphone",                     limit: 20,  default: ""
    t.string   "website",                       limit: 50,  default: ""
    t.string   "gender",                        limit: 1,   default: ""
    t.integer  "status",                                    default: 0
    t.integer  "lock_version",                              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "email",                         limit: 255
    t.string   "public_avatar",                 limit: 255
    t.integer  "public_avatar_file_size"
    t.string   "public_avatar_content_type",    limit: 255
    t.string   "private_avatar",                limit: 255
    t.integer  "private_avatar_file_size"
    t.string   "private_avatar_content_type",   limit: 255
    t.boolean  "use_private_avatar_for_public",             default: false
    t.string   "favored_locale"
  end

  create_table "user_site_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "last_access_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "uuid",           limit: 40
  end

  add_index "user_site_profiles", ["uuid"], name: "index_user_site_profiles_on_uuid"

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id"
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id"

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,        null: false
    t.integer  "item_id",                           null: false
    t.string   "event",          limit: 255,        null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 1073741823
    t.datetime "created_at"
    t.text     "object_changes", limit: 1073741823
    t.string   "locale",         limit: 255
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id"

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "voter_id"
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
