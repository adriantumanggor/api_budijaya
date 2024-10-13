class Jabatan < ApplicationRecord
  self.table_name = "jabatan"

  has_many :karyawan, class_name: "Karyawan"

  validates :nama_jabatan, presence: true, length: { maximum: 100 }

  def self.by_nama(nama)
    where("nama_jabatan ILIKE ?", "%#{nama}%")
  end
end
