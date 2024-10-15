class Absensi < ApplicationRecord
  self.table_name = "absensi"

  belongs_to :karyawan

  validates :tanggal, presence: true
  validates :status_absensi, inclusion: { in: %w[hadir izin] }

  scope :by_karyawan, ->(karyawan_id) { where(karyawan_id: karyawan_id) }
  scope :by_tanggal, ->(tanggal) { where(tanggal: tanggal) }
  scope :by_waktu_masuk, ->(waktu) { where("waktu_masuk <= ?", waktu) }
  scope :by_waktu_keluar, ->(waktu) { where("waktu_keluar >= ?", waktu) }
  scope :by_status_absensi, ->(status) { where(status_absensi: status) }
end