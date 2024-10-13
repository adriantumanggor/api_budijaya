class Absensi < ApplicationRecord
  self.table_name = "absensi"

  belongs_to :karyawan, class_name: "Karyawan"

  validates :tanggal, presence: true
  validates :status_absensi, inclusion: { in: %w[hadir izin] }

  def self.by_karyawan(karyawan_id)
    where(karyawan_id: karyawan_id)
  end

  def self.by_tanggal(tanggal)
    where(tanggal: tanggal)
  end

  def self.by_waktu_masuk(waktu)
    where("waktu_masuk <= ?", waktu)
  end

  def self.by_waktu_keluar(waktu)
    where("waktu_keluar >= ?", waktu)
  end

  def self.by_status_absensi(status)
    where(status_absensi: status)
  end
end
