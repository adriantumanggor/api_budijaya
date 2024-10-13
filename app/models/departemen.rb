class Departemen < ApplicationRecord
  self.table_name = "departemen"

  has_many :karyawan, class_name: "Karyawan"

  validates :nama_departemen, presence: true, length: { maximum: 100 }
  
  def self.by_nama(nama)
    where("nama_departemen ILIKE ?", "%#{nama}%")
  end
end
