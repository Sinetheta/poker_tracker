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

ActiveRecord::Schema.define(version: 20160922230920) do

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "mnuid_it"
    t.integer  "pizzapage_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "url"
  end

  add_index "categories", ["pizzapage_id"], name: "index_categories_on_pizzapage_id"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "chips"
    t.float    "game_length"
    t.integer  "round_length"
    t.integer  "round",                 default: 0
    t.integer  "first_small_blind"
    t.integer  "smallest_denomination"
    t.text     "blinds",                default: "---\n- 1\n"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "buy_in"
    t.boolean  "complete",              default: false
    t.integer  "saved_timer"
  end

  create_table "guests", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pizza_configs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "webpage_path"
    t.string   "menu_path"
    t.string   "item_path"
    t.string   "checkout_path"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "ordernote"
    t.string   "address"
    t.string   "company"
    t.string   "buzzer"
    t.string   "city"
    t.string   "postal_code"
    t.string   "payment_method"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "pizza_configs", ["user_id"], name: "index_pizza_configs_on_user_id"

  create_table "pizza_orders", force: :cascade do |t|
    t.string   "cookiespath"
    t.integer  "cart_id"
    t.integer  "pizzapage_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "total"
  end

  add_index "pizza_orders", ["cart_id"], name: "index_pizza_orders_on_cart_id"
  add_index "pizza_orders", ["pizzapage_id"], name: "index_pizza_orders_on_pizzapage_id"

  create_table "pizzapages", force: :cascade do |t|
    t.string   "webpage_path"
    t.string   "menu_path"
    t.string   "item_path"
    t.string   "checkout_path"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "url"
  end

  create_table "players", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "winner"
    t.integer  "round_out"
    t.integer  "position_out"
    t.integer  "user_id"
    t.integer  "guest_id"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"
  add_index "players", ["guest_id"], name: "index_players_on_guest_id"
  add_index "players", ["user_id"], name: "index_players_on_user_id"

  create_table "product_orders", force: :cascade do |t|
    t.integer  "product_id"
    t.text     "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cart_id"
  end

  add_index "product_orders", ["cart_id"], name: "index_product_orders_on_cart_id"
  add_index "product_orders", ["product_id"], name: "index_product_orders_on_product_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "iid_it"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
    t.text     "options"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id"

  create_table "saved_orders", force: :cascade do |t|
    t.text     "order"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "saved_orders", ["user_id"], name: "index_saved_orders_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
