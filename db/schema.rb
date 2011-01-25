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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110125203803) do

  create_table "icd_codes", :force => true do |t|
    t.string   "identifier"
    t.string   "short_description"
    t.string   "medium_description"
    t.text     "description"
    t.string   "code_type"
    t.boolean  "mcc"
    t.boolean  "cc"
    t.date     "activated"
    t.date     "deactivated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.boolean  "test_1"
    t.string   "test_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_1"
    t.string   "column_2"
    t.string   "column_3"
    t.string   "column_4"
  end

end
