class Departemen < ApplicationRecord
  self.table_name = "departemen"

  has_many :karyawan, class_name: "Karyawan"
  belongs_to :manager, class_name: "Karyawan", optional: true

  validates :name, length: { maximum: 100 }


  def self.with_manager_name
    left_joins(:manager)
      .select('departemen.id', 'departemen.name', 'karyawan.name AS manager_name', 'departemen.manager_id')
  end

end
