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

ActiveRecord::Schema[7.0].define(version: 2023_05_18_190201) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "building_parts", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.bigint "organization_id", null: false
    t.string "state"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_parts_on_building_id"
    t.index ["organization_id"], name: "index_building_parts_on_organization_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_buildings_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "building_part_id", null: false
    t.string "point_type"
    t.string "name"
    t.string "description"
    t.integer "x_value"
    t.integer "y_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_part_id"], name: "index_points_on_building_part_id"
    t.index ["organization_id"], name: "index_points_on_organization_id"
  end

  create_table "roads", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "building_part_id", null: false
    t.bigint "point1_id", null: false
    t.bigint "point2_id", null: false
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_part_id"], name: "index_roads_on_building_part_id"
    t.index ["organization_id"], name: "index_roads_on_organization_id"
    t.index ["point1_id"], name: "index_roads_on_point1_id"
    t.index ["point2_id"], name: "index_roads_on_point2_id"
  end

  add_foreign_key "building_parts", "buildings"
  add_foreign_key "building_parts", "organizations"
  add_foreign_key "buildings", "organizations"
  add_foreign_key "points", "building_parts"
  add_foreign_key "points", "organizations"
  add_foreign_key "roads", "building_parts"
  add_foreign_key "roads", "organizations"
  add_foreign_key "roads", "points", column: "point1_id"
  add_foreign_key "roads", "points", column: "point2_id"
end
