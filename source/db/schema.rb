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

ActiveRecord::Schema[7.1].define(version: 2024_09_26_231449) do
  create_table "evaluations", force: :cascade do |t|
    t.string "status", default: "pending", null: false
    t.date "date_completed", null: false
    t.integer "project_id", null: false
    t.integer "student_id", null: false
    t.float "cooperation_rating", null: false
    t.float "conceptual_rating", null: false
    t.float "practical_rating", null: false
    t.float "work_ethic_rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "due_date"
    t.integer "team_id"
    t.integer "instructor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "course_name"
    t.integer "instructor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.integer "team_id"
    t.float "cooperation_rating"
    t.float "conceptual_rating"
    t.float "practical_rating"
    t.float "work_ethic_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instructor_id"
    t.string "sex"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
