class Departemen < ApplicationRecord
  self.table_name = "departemen"

  has_many :karyawan

  validates :nama_departemen, presence: true, length: { maximum: 100 }

  scope :by_nama, ->(nama) { where("nama_departemen ILIKE ?", "%#{nama}%") }
end
