# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_25_165405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "criteria_type", null: false
    t.integer "criteria_value", null: false
    t.text "description", null: false
    t.string "icon", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_achievements_on_active"
    t.index ["criteria_type"], name: "index_achievements_on_criteria_type"
    t.index ["name"], name: "index_achievements_on_name", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id", "created_at"], name: "index_follows_on_followed_id_and_created_at"
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "created_at"], name: "index_follows_on_follower_id_and_created_at"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "raffle_tickets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "purchased_at", null: false
    t.bigint "raffle_id", null: false
    t.bigint "referred_user_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["raffle_id", "user_id"], name: "index_raffle_tickets_on_raffle_id_and_user_id"
    t.index ["raffle_id"], name: "index_raffle_tickets_on_raffle_id"
    t.index ["referred_user_id"], name: "index_raffle_tickets_on_referred_user_id"
    t.index ["user_id", "referred_user_id"], name: "index_raffle_tickets_on_user_and_referred_user", unique: true, where: "(referred_user_id IS NOT NULL)"
    t.index ["user_id"], name: "index_raffle_tickets_on_user_id"
  end

  create_table "raffle_views", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.bigint "raffle_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.datetime "viewed_at", null: false
    t.index ["raffle_id", "user_id", "viewed_at"], name: "index_raffle_views_on_raffle_user_viewed"
    t.index ["raffle_id", "viewed_at"], name: "index_raffle_views_on_raffle_id_and_viewed_at"
    t.index ["raffle_id"], name: "index_raffle_views_on_raffle_id"
    t.index ["user_id"], name: "index_raffle_views_on_user_id"
  end

  create_table "raffles", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "completed_at"
    t.string "condition", null: false
    t.datetime "created_at", null: false
    t.datetime "drawn_at"
    t.datetime "end_date", null: false
    t.string "name", null: false
    t.decimal "platform_fee_percent"
    t.decimal "price", precision: 10, scale: 2
    t.string "status", null: false
    t.decimal "ticket_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "winner_id"
    t.index ["user_id"], name: "index_raffles_on_user_id"
    t.index ["winner_id"], name: "index_raffles_on_winner_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "direction", null: false
    t.bigint "related_id"
    t.string "related_type"
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "wallet_id", null: false
    t.index ["created_at"], name: "index_transactions_on_created_at"
    t.index ["related_type", "related_id"], name: "index_transactions_on_related"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.string "achievement_name", null: false
    t.datetime "created_at", null: false
    t.datetime "earned_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["achievement_name"], name: "index_user_achievements_on_achievement_name"
    t.index ["earned_at"], name: "index_user_achievements_on_earned_at"
    t.index ["user_id", "achievement_name"], name: "index_user_achievements_on_user_id_and_achievement_name", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.string "activity_type", null: false
    t.datetime "created_at", null: false
    t.bigint "subject_id", null: false
    t.string "subject_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["activity_type", "created_at"], name: "index_user_activities_on_activity_type_and_created_at"
    t.index ["subject_type", "subject_id"], name: "index_user_activities_on_subject"
    t.index ["user_id", "created_at"], name: "index_user_activities_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "referral_code"
    t.bigint "referred_by_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["referred_by_id"], name: "index_users_on_referred_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "raffle_tickets", "raffles"
  add_foreign_key "raffle_tickets", "users"
  add_foreign_key "raffle_tickets", "users", column: "referred_user_id"
  add_foreign_key "raffle_views", "raffles"
  add_foreign_key "raffle_views", "users"
  add_foreign_key "raffles", "users"
  add_foreign_key "raffles", "users", column: "winner_id"
  add_foreign_key "transactions", "wallets"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_activities", "users"
  add_foreign_key "users", "users", column: "referred_by_id"
  add_foreign_key "wallets", "users"
end
