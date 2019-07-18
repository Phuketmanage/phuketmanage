# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_18_092452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.date "start"
    t.date "finish"
    t.bigint "house_id", null: false
    t.bigint "tenant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.string "number"
    t.string "ical_UID"
    t.integer "source_id"
    t.text "comment"
    t.integer "sale"
    t.integer "agent"
    t.integer "comm"
    t.integer "nett"
    t.boolean "synced", default: false
    t.index ["house_id"], name: "index_bookings_on_house_id"
    t.index ["number"], name: "index_bookings_on_number", unique: true
    t.index ["source_id"], name: "index_bookings_on_source_id"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["synced"], name: "index_bookings_on_synced"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
  end

  create_table "connections", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.bigint "source_id", null: false
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_sync"
    t.index ["house_id"], name: "index_connections_on_house_id"
    t.index ["source_id"], name: "index_connections_on_source_id"
  end

  create_table "durations", force: :cascade do |t|
    t.integer "start"
    t.integer "finish"
    t.bigint "house_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["house_id"], name: "index_durations_on_house_id"
  end

  create_table "house_types", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comm"
  end

  create_table "houses", force: :cascade do |t|
    t.string "title_en"
    t.string "title_ru"
    t.text "description_en"
    t.text "description_ru"
    t.bigint "owner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "type_id", null: false
    t.string "code"
    t.integer "size"
    t.integer "plot_size"
    t.integer "rooms"
    t.integer "bathrooms"
    t.boolean "pool"
    t.string "pool_size"
    t.boolean "communal_pool"
    t.boolean "parking"
    t.integer "parking_size"
    t.boolean "unavailable", default: false
    t.string "number", limit: 10
    t.string "secret"
    t.index ["bathrooms"], name: "index_houses_on_bathrooms"
    t.index ["code"], name: "index_houses_on_code"
    t.index ["communal_pool"], name: "index_houses_on_communal_pool"
    t.index ["number"], name: "index_houses_on_number", unique: true
    t.index ["owner_id"], name: "index_houses_on_owner_id"
    t.index ["parking"], name: "index_houses_on_parking"
    t.index ["rooms"], name: "index_houses_on_rooms"
    t.index ["type_id"], name: "index_houses_on_type_id"
    t.index ["unavailable"], name: "index_houses_on_unavailable"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.integer "season_id"
    t.integer "duration_id"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["duration_id"], name: "index_prices_on_duration_id"
    t.index ["house_id"], name: "index_prices_on_house_id"
    t.index ["season_id"], name: "index_prices_on_season_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "ssd"
    t.integer "ssm"
    t.integer "sfd"
    t.integer "sfm"
    t.bigint "house_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["house_id"], name: "index_seasons_on_house_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var"
    t.string "value"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "name"
    t.string "surname"
    t.string "locale"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "houses"
  add_foreign_key "bookings", "users", column: "tenant_id"
  add_foreign_key "connections", "houses"
  add_foreign_key "connections", "sources"
  add_foreign_key "durations", "houses"
  add_foreign_key "houses", "house_types", column: "type_id"
  add_foreign_key "houses", "users", column: "owner_id"
  add_foreign_key "prices", "houses"
  add_foreign_key "seasons", "houses"
end
