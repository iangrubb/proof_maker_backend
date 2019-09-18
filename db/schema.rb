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

ActiveRecord::Schema.define(version: 2019_09_18_171804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "citations", force: :cascade do |t|
    t.bigint "justification_id", null: false
    t.bigint "citeable_id"
    t.string "citeable_type"
    t.integer "citation_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["citeable_type", "citeable_id"], name: "index_citations_on_citeable_type_and_citeable_id"
    t.index ["justification_id"], name: "index_citations_on_justification_id"
  end

  create_table "justifications", force: :cascade do |t|
    t.bigint "stage_id", null: false
    t.string "rule"
    t.bigint "line_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_id"], name: "index_justifications_on_line_id"
    t.index ["stage_id"], name: "index_justifications_on_stage_id"
  end

  create_table "lines", force: :cascade do |t|
    t.bigint "stage_id", null: false
    t.bigint "subproof_id", null: false
    t.integer "stage_order"
    t.integer "goal_id"
    t.jsonb "sentence"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stage_id"], name: "index_lines_on_stage_id"
    t.index ["subproof_id"], name: "index_lines_on_subproof_id"
  end

  create_table "proofs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ptype_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ptype_id"], name: "index_proofs_on_ptype_id"
    t.index ["user_id"], name: "index_proofs_on_user_id"
  end

  create_table "ptypes", force: :cascade do |t|
    t.jsonb "sentences"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stages", force: :cascade do |t|
    t.bigint "proof_id", null: false
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["proof_id"], name: "index_stages_on_proof_id"
  end

  create_table "subproofs", force: :cascade do |t|
    t.bigint "stage_id", null: false
    t.integer "stage_order"
    t.integer "subproof_id"
    t.integer "goal_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stage_id"], name: "index_subproofs_on_stage_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "citations", "justifications"
  add_foreign_key "justifications", "lines"
  add_foreign_key "justifications", "stages"
  add_foreign_key "lines", "stages"
  add_foreign_key "lines", "subproofs"
  add_foreign_key "proofs", "ptypes"
  add_foreign_key "proofs", "users"
  add_foreign_key "stages", "proofs"
  add_foreign_key "subproofs", "stages"
end
