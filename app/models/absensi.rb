class Absensi < ApplicationRecord
  self.table_name = "absensi"

  belongs_to :karyawan, class_name: "Karyawan"

  validates :tanggal, presence: true
  validates :status_absensi, inclusion: { in: %w[hadir izin] }
end
