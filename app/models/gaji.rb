class Gaji < ApplicationRecord
  self.table_name = "gaji"

  belongs_to :karyawan, class_name: "Karyawan"

  validates :bulan, presence: true
  validates :gaji_pokok, :tunjangan, :potongan, :total_gaji, numericality: { greater_than_or_equal_to: 0 }
end
