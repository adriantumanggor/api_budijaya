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

ActiveRecord::Schema[7.2].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absensi", id: :serial, force: :cascade do |t|
    t.integer "karyawan_id"
    t.date "tanggal", null: false
    t.time "waktu_masuk"
    t.time "waktu_keluar"
    t.string "status_absensi", limit: 6, null: false
    t.check_constraint "status_absensi::text = ANY (ARRAY['hadir'::character varying, 'izin'::character varying, 'sakit'::character varying, 'alpha'::character varying]::text[])", name: "absensi_status_absensi_check"
  end

  create_table "departemen", id: :serial, force: :cascade do |t|
    t.string "nama_departemen", limit: 100, null: false
  end

  create_table "gaji", id: :serial, force: :cascade do |t|
    t.integer "karyawan_id"
    t.string "bulan", limit: 10, null: false
    t.decimal "gaji_pokok", precision: 10, scale: 2, null: false
    t.decimal "tunjangan", precision: 10, scale: 2
    t.decimal "potongan", precision: 10, scale: 2
    t.decimal "total_gaji", precision: 10, scale: 2
  end

  create_table "jabatan", id: :serial, force: :cascade do |t|
    t.string "nama_jabatan", limit: 100, null: false
  end

  create_table "karyawan", id: :serial, force: :cascade do |t|
    t.string "nama_lengkap", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.string "nomor_telepon", limit: 15
    t.date "tanggal_lahir"
    t.text "alamat"
    t.date "tanggal_masuk"
    t.integer "departemen_id"
    t.integer "jabatan_id"
    t.string "status", limit: 8, null: false

    t.check_constraint "status::text = ANY (ARRAY['aktif'::character varying, 'nonaktif'::character varying]::text[])", name: "karyawan_status_check"
    t.unique_constraint ["email"], name: "karyawan_email_key"
  end

  add_foreign_key "absensi", "karyawan", name: "absensi_karyawan_id_fkey"
  add_foreign_key "gaji", "karyawan", name: "gaji_karyawan_id_fkey"
  add_foreign_key "karyawan", "departemen", column: "departemen_id", name: "karyawan_departemen_id_fkey"
  add_foreign_key "karyawan", "jabatan", name: "karyawan_jabatan_id_fkey"
end
