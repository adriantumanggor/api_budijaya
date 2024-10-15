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

  scope :by_nama, ->(nama) { where("nama_lengkap ILIKE ?", "%#{nama}%") }
  scope :by_email, ->(email) { where("email ILIKE ?", "%#{email}%") }
  scope :by_nomor_telepon, ->(nomor) { where("nomor_telepon LIKE ?", "%#{nomor}%") }
  scope :by_tanggal_lahir, ->(tanggal) { where(tanggal_lahir: tanggal) }
  scope :by_alamat, ->(alamat) { where("alamat ILIKE ?", "%#{alamat}%") }
  scope :by_tanggal_masuk, ->(tanggal) { where(tanggal_masuk: tanggal) }
  scope :by_departemen_id, ->(departemen_id) { where(departemen_id: departemen_id) }
  scope :by_jabatan_id, ->(jabatan_id) { where(jabatan_id: jabatan_id) }
  scope :by_status, ->(status) { where(status: status) }
end
