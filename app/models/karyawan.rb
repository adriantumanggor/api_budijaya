class Karyawan < ApplicationRecord
  self.table_name = "karyawan"

  belongs_to :departemen, class_name: "Departemen"
  belongs_to :jabatan, class_name: "Jabatan"
  has_many :absensi, class_name: "Absensi"
  has_many :gaji, class_name: "Gaji"

  validates :nama_lengkap, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :nomor_telepon, length: { maximum: 15 }, allow_blank: true
  validates :status, inclusion: { in: %w[aktif nonaktif] }
end
