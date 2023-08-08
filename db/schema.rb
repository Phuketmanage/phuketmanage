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

ActiveRecord::Schema[7.0].define(version: 2023_08_08_134534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "balance_outs", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.decimal "debit", precision: 9, scale: 2
    t.decimal "credit", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ref_no_iv"
    t.string "ref_no_re"
    t.string "ref_no"
    t.index ["transaction_id"], name: "index_balance_outs_on_transaction_id"
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.decimal "debit", precision: 9, scale: 2
    t.decimal "credit", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ref_no"
    t.index ["transaction_id"], name: "index_balances_on_transaction_id"
  end

  create_table "booking_files", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "url"
    t.string "name"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["booking_id"], name: "index_booking_files_on_booking_id"
    t.index ["user_id"], name: "index_booking_files_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.date "start"
    t.date "finish"
    t.bigint "house_id", null: false
    t.bigint "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "allotment", default: false
    t.boolean "transfer_in", default: false
    t.boolean "transfer_out", default: false
    t.string "client_details"
    t.text "comment_gr"
    t.boolean "no_check_in", default: false
    t.boolean "no_check_out", default: false
    t.date "check_in"
    t.date "check_out"
    t.string "comment_owner"
    t.boolean "ignore_warnings", default: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_sync", precision: nil
    t.index ["house_id"], name: "index_connections_on_house_id"
    t.index ["source_id"], name: "index_connections_on_source_id"
  end

  create_table "durations", force: :cascade do |t|
    t.integer "start"
    t.integer "finish"
    t.bigint "house_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_durations_on_house_id"
  end

  create_table "empl_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "empl_types_job_types", id: false, force: :cascade do |t|
    t.bigint "job_type_id", null: false
    t.bigint "empl_type_id", null: false
    t.index ["job_type_id", "empl_type_id"], name: "index_empl_types_job_types_on_job_type_id_and_empl_type_id", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "type_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type_id"], name: "index_employees_on_type_id"
  end

  create_table "employees_houses", id: false, force: :cascade do |t|
    t.bigint "house_id", null: false
    t.bigint "employee_id", null: false
    t.index ["house_id", "employee_id"], name: "index_employees_houses_on_house_id_and_employee_id", unique: true
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "house_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "house_options", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.bigint "option_id", null: false
    t.string "comment_en"
    t.string "comment_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_house_options_on_house_id"
    t.index ["option_id"], name: "index_house_options_on_option_id"
  end

  create_table "house_photos", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.string "url"
    t.string "title_en"
    t.string "title_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["house_id"], name: "index_house_photos_on_house_id"
  end

  create_table "house_types", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comm"
  end

  create_table "houses", force: :cascade do |t|
    t.string "title_en"
    t.string "title_ru"
    t.text "description_en"
    t.text "description_ru"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "rental", default: false
    t.boolean "maintenance", default: false
    t.boolean "outsource_cleaning", default: false
    t.boolean "outsource_linen", default: false
    t.string "address"
    t.string "google_map"
    t.string "image"
    t.integer "capacity"
    t.boolean "seaview", default: false
    t.integer "kingBed"
    t.integer "queenBed"
    t.integer "singleBed"
    t.text "priceInclude_en"
    t.text "priceInclude_ru"
    t.text "cancellationPolicy_en"
    t.text "cancellationPolicy_ru"
    t.text "rules_en"
    t.text "rules_ru"
    t.text "other_ru"
    t.text "other_en"
    t.text "details"
    t.bigint "house_group_id"
    t.integer "water_meters", default: 1
    t.boolean "water_reading", default: false
    t.boolean "balance_closed", default: false, null: false
    t.boolean "hide_in_timeline", default: false, null: false
    t.string "photo_link"
    t.string "project"
    t.index ["bathrooms"], name: "index_houses_on_bathrooms"
    t.index ["code"], name: "index_houses_on_code"
    t.index ["communal_pool"], name: "index_houses_on_communal_pool"
    t.index ["house_group_id"], name: "index_houses_on_house_group_id"
    t.index ["number"], name: "index_houses_on_number", unique: true
    t.index ["owner_id"], name: "index_houses_on_owner_id"
    t.index ["parking"], name: "index_houses_on_parking"
    t.index ["rooms"], name: "index_houses_on_rooms"
    t.index ["type_id"], name: "index_houses_on_type_id"
    t.index ["unavailable"], name: "index_houses_on_unavailable"
  end

  create_table "houses_locations", id: false, force: :cascade do |t|
    t.bigint "house_id", null: false
    t.bigint "location_id", null: false
    t.index ["house_id", "location_id"], name: "index_houses_locations_on_house_id_and_location_id"
  end

  create_table "job_messages", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "sender_id", null: false
    t.text "message"
    t.boolean "is_system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "file", default: false
    t.index ["job_id"], name: "index_job_messages_on_job_id"
    t.index ["sender_id"], name: "index_job_messages_on_sender_id"
  end

  create_table "job_tracks", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "user_id", null: false
    t.datetime "visit_time", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_tracks_on_job_id"
    t.index ["user_id"], name: "index_job_tracks_on_user_id"
  end

  create_table "job_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "color"
    t.boolean "for_house_only"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "job_type_id", null: false
    t.bigint "booking_id"
    t.bigint "house_id"
    t.string "time"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.date "plan"
    t.date "closed"
    t.text "job"
    t.bigint "creator_id", null: false
    t.bigint "employee_id"
    t.date "collected"
    t.date "sent"
    t.integer "rooms"
    t.integer "price"
    t.string "before"
    t.integer "status", default: 0
    t.boolean "urgent", default: false
    t.boolean "paid_by_tenant", default: false, null: false
    t.index ["booking_id"], name: "index_jobs_on_booking_id"
    t.index ["creator_id"], name: "index_jobs_on_creator_id"
    t.index ["employee_id"], name: "index_jobs_on_employee_id"
    t.index ["house_id"], name: "index_jobs_on_house_id"
    t.index ["job_type_id"], name: "index_jobs_on_job_type_id"
    t.index ["status"], name: "index_jobs_on_status"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ru"
    t.text "descr_en"
    t.text "descr_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_email"
    t.string "model_gid"
    t.jsonb "user_roles"
    t.jsonb "before_values"
    t.jsonb "applied_changes"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "level"
    t.string "text"
    t.bigint "house_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_notifications_on_house_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "title_en"
    t.string "title_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zindex"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.integer "season_id"
    t.integer "duration_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duration_id"], name: "index_prices_on_duration_id"
    t.index ["house_id"], name: "index_prices_on_house_id"
    t.index ["season_id"], name: "index_prices_on_season_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_seasons_on_house_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var"
    t.string "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "syncable", default: false
    t.index ["syncable"], name: "index_sources_on_syncable"
  end

  create_table "transaction_files", force: :cascade do |t|
    t.bigint "trsc_id", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: false
    t.index ["trsc_id"], name: "index_transaction_files_on_trsc_id"
  end

  create_table "transaction_types", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ru"
    t.boolean "debit_company"
    t.boolean "credit_company"
    t.boolean "debit_owner"
    t.boolean "credit_owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin_only", default: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "ref_no"
    t.bigint "house_id"
    t.bigint "type_id"
    t.bigint "user_id"
    t.string "comment_en"
    t.string "comment_ru"
    t.string "comment_inner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.bigint "booking_id"
    t.boolean "hidden", default: false
    t.boolean "for_acc", default: false
    t.boolean "incomplite", default: false, null: false
    t.boolean "cash", default: false, null: false
    t.boolean "transfer", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.index ["booking_id"], name: "index_transactions_on_booking_id"
    t.index ["house_id"], name: "index_transactions_on_house_id"
    t.index ["type_id"], name: "index_transactions_on_type_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.bigint "booking_id"
    t.date "date"
    t.integer "trsf_type"
    t.string "from"
    t.string "time"
    t.string "client"
    t.string "pax"
    t.string "to"
    t.string "remarks"
    t.string "booked_by"
    t.string "number"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_transfers_on_booking_id"
    t.index ["number"], name: "index_transfers_on_number"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "name"
    t.string "surname"
    t.string "locale"
    t.text "comment"
    t.string "code"
    t.string "tax_no"
    t.boolean "show_comm", default: false
    t.boolean "balance_closed", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "water_usages", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.date "date"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_2"
    t.string "comment"
    t.index ["house_id"], name: "index_water_usages_on_house_id"
  end

  add_foreign_key "balance_outs", "transactions"
  add_foreign_key "balances", "transactions"
  add_foreign_key "booking_files", "bookings"
  add_foreign_key "booking_files", "users"
  add_foreign_key "bookings", "houses"
  add_foreign_key "bookings", "sources", name: "bookings_source_id_fk"
  add_foreign_key "bookings", "users", column: "tenant_id"
  add_foreign_key "connections", "houses"
  add_foreign_key "connections", "sources"
  add_foreign_key "durations", "houses"
  add_foreign_key "empl_types_job_types", "empl_types", name: "empl_types_job_types_empl_type_id_fk"
  add_foreign_key "empl_types_job_types", "job_types", name: "empl_types_job_types_job_type_id_fk"
  add_foreign_key "employees", "empl_types", column: "type_id"
  add_foreign_key "employees_houses", "employees", name: "employees_houses_employee_id_fk"
  add_foreign_key "employees_houses", "houses", name: "employees_houses_house_id_fk"
  add_foreign_key "house_options", "houses"
  add_foreign_key "house_options", "options"
  add_foreign_key "house_photos", "houses"
  add_foreign_key "houses", "house_groups"
  add_foreign_key "houses", "house_types", column: "type_id"
  add_foreign_key "houses", "users", column: "owner_id"
  add_foreign_key "houses_locations", "houses", name: "houses_locations_house_id_fk"
  add_foreign_key "houses_locations", "locations", name: "houses_locations_location_id_fk"
  add_foreign_key "job_messages", "jobs"
  add_foreign_key "job_messages", "users", column: "sender_id"
  add_foreign_key "job_tracks", "jobs"
  add_foreign_key "job_tracks", "users"
  add_foreign_key "jobs", "bookings"
  add_foreign_key "jobs", "employees"
  add_foreign_key "jobs", "houses"
  add_foreign_key "jobs", "job_types"
  add_foreign_key "jobs", "users"
  add_foreign_key "jobs", "users", column: "creator_id"
  add_foreign_key "notifications", "houses"
  add_foreign_key "prices", "houses"
  add_foreign_key "roles_users", "roles", name: "roles_users_role_id_fk"
  add_foreign_key "roles_users", "users", name: "roles_users_user_id_fk"
  add_foreign_key "seasons", "houses"
  add_foreign_key "transaction_files", "transactions", column: "trsc_id"
  add_foreign_key "transactions", "bookings"
  add_foreign_key "transactions", "houses"
  add_foreign_key "transactions", "transaction_types", column: "type_id"
  add_foreign_key "transactions", "users"
  add_foreign_key "transfers", "bookings"
  add_foreign_key "water_usages", "houses"
end
