# app/models/cuti.rb
class Cuti < ApplicationRecord
  self.table_name = "cuti"

  # Associations
  belongs_to :karyawan, class_name: "Karyawan", foreign_key: "karyawan_id", optional: true

  # Validations
  validates :karyawan_id, presence: true
  validates :tanggal_mulai, presence: true
  validates :tanggal_selesai, presence: true
  validates :jenis_cuti, presence: true
  validates :status, presence: true
end
