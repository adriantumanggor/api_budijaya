class Jabatan < ApplicationRecord
  self.table_name = "jabatan"

  has_many :karyawan, class_name: "Karyawan"

  validates :nama_jabatan, presence: true, length: { maximum: 100 }

  scope :by_nama, ->(nama) { where(nama_jabatan: nama) }

  def self.apply_filters(params)
    jabatan = Jabatan.all
    filtered = false

    if params[:nama_jabatan].present?
      jabatan = jabatan.by_nama(params[:nama_jabatan])
      filtered = true
    end

    return jabatan, filtered
  end

end
