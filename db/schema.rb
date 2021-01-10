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

ActiveRecord::Schema.define(version: 0) do

  create_table "business_demand_elements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "occupation_id"
    t.bigint "industry_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_business_demand_elements_on_business_id"
    t.index ["industry_id"], name: "index_business_demand_elements_on_industry_id"
    t.index ["occupation_id"], name: "index_business_demand_elements_on_occupation_id"
  end

  create_table "business_supply_elements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "occupation_id"
    t.bigint "industry_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_business_supply_elements_on_business_id"
    t.index ["industry_id"], name: "index_business_supply_elements_on_industry_id"
    t.index ["occupation_id"], name: "index_business_supply_elements_on_occupation_id"
  end

  create_table "businesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.integer "status", default: 0
    t.text "detail"
    t.string "image"
    t.string "hp_link"
    t.string "code"
    t.bigint "user_id"
    t.bigint "prefecture_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_businesses_on_prefecture_id"
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "connection_notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "connection_request_id"
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["connection_request_id"], name: "index_connection_notifications_on_connection_request_id"
    t.index ["user_id"], name: "index_connection_notifications_on_user_id"
  end

  create_table "connection_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "connector_id"
    t.bigint "from_user_id"
    t.bigint "to_user_id"
    t.integer "connection_type"
    t.integer "status", default: 1
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["connector_id"], name: "index_connection_requests_on_connector_id"
    t.index ["from_user_id"], name: "index_connection_requests_on_from_user_id"
    t.index ["to_user_id"], name: "index_connection_requests_on_to_user_id"
  end

  create_table "external_credentials", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.text "token"
    t.string "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_external_credentials_on_user_id"
  end

  create_table "industries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_industries_on_ancestry"
  end

  create_table "message_room_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "message_room_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_room_id"], name: "index_message_room_users_on_message_room_id"
    t.index ["user_id"], name: "index_message_room_users_on_user_id"
  end

  create_table "message_rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "message_room_id"
    t.bigint "user_id"
    t.text "text"
    t.datetime "posted_at"
    t.index ["message_room_id"], name: "index_messages_on_message_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "text"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "occupations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_occupations_on_ancestry"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "price"
    t.integer "list_capacity"
    t.integer "status", default: 0
  end

  create_table "point_log", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "point"
    t.bigint "connector_id"
    t.bigint "from_user_id"
    t.bigint "to_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["connector_id"], name: "index_point_log_on_connector_id"
    t.index ["from_user_id"], name: "index_point_log_on_from_user_id"
    t.index ["to_user_id"], name: "index_point_log_on_to_user_id"
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "name_kana"
    t.string "name_en"
  end

  create_table "user_connections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_user_connections_on_friend_id"
    t.index ["user_id"], name: "index_user_connections_on_user_id"
  end

  create_table "user_plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plan_id"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_user_plans_on_plan_id"
    t.index ["user_id"], name: "index_user_plans_on_user_id"
  end

  create_table "user_scores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "point", default: 0
    t.integer "all_rank"
    t.integer "local_rank"
    t.integer "latest_monthly_rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.integer "status", default: 1
    t.string "name"
    t.string "email"
    t.integer "gender", default: 0
    t.date "birthday"
    t.string "avatar_image"
    t.string "cover_image"
    t.text "detail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "business_demand_elements", "businesses"
  add_foreign_key "business_demand_elements", "industries"
  add_foreign_key "business_demand_elements", "occupations"
  add_foreign_key "business_supply_elements", "businesses"
  add_foreign_key "business_supply_elements", "industries"
  add_foreign_key "business_supply_elements", "occupations"
  add_foreign_key "businesses", "prefectures"
  add_foreign_key "businesses", "users"
  add_foreign_key "connection_requests", "users", column: "connector_id"
  add_foreign_key "connection_requests", "users", column: "from_user_id"
  add_foreign_key "connection_requests", "users", column: "to_user_id"
  add_foreign_key "external_credentials", "users"
  add_foreign_key "point_log", "users", column: "connector_id"
  add_foreign_key "point_log", "users", column: "from_user_id"
  add_foreign_key "point_log", "users", column: "to_user_id"
  add_foreign_key "user_connections", "users"
  add_foreign_key "user_connections", "users", column: "friend_id"
  add_foreign_key "user_plans", "plans"
  add_foreign_key "user_plans", "users"
end
