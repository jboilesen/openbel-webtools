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

ActiveRecord::Schema.define(version: 20140808083253) do

  create_table "belfiles", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "belfile_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edges", force: true do |t|
    t.string   "relation"
    t.integer  "source_id"
    t.integer  "target_id"
    t.integer  "graph_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edges", ["graph_id"], name: "index_edges_on_graph_id", using: :btree
  add_index "edges", ["source_id"], name: "index_edges_on_source_id", using: :btree
  add_index "edges", ["target_id"], name: "index_edges_on_target_id", using: :btree

  create_table "graphs", force: true do |t|
    t.string   "label"
    t.boolean  "directed"
    t.integer  "belfile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graphs", ["belfile_id"], name: "index_graphs_on_belfile_id", using: :btree

  create_table "nodes", force: true do |t|
    t.string   "label"
    t.string   "fx"
    t.integer  "graph_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["graph_id"], name: "index_nodes_on_graph_id", using: :btree
  add_index "nodes", ["label"], name: "index_nodes_on_label", using: :btree

end
