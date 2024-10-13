class Gaji < ApplicationRecord
  self.table_name = "gaji"

  belongs_to :karyawan, class_name: "Karyawan"

  validates :bulan, presence: true
  validates :gaji_pokok, :tunjangan, :potongan, :total_gaji, numericality: { greater_than_or_equal_to: 0 }

  def self.by_karyawan(karyawan_id)
    where(karyawan_id: karyawan_id)
  end

  def self.by_bulan(bulan)
    where(bulan: bulan)
  end

  def self.by_gaji_pokok_range(min, max)
    where(gaji_pokok: min..max)
  end

  def self.by_tunjangan_range(min, max)
    where(tunjangan: min..max)
  end

  def self.by_potongan_range(min, max)
    where(potongan: min..max)
  end

  def self.by_total_gaji_range(min, max)
    where(total_gaji: min..max)
  end
end
