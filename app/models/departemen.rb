class Departemen < ApplicationRecord
  self.table_name = "departemen"

  has_many :karyawan

  validates :nama_departemen, presence: true, length: { maximum: 100 }

  scope :by_nama, ->(nama) { where(nama_departemen: nama) }

  def self.apply_filters(params)
    departemen = Departemen.all
    filtered = false

    if params[:nama_departemen].present?
      departemen = departemen.by_nama(params[:nama_departemen])
      filtered = true
    end

    return departemen, filtered
  end

end
