class Gaji < ApplicationRecord
  self.table_name = "gaji"

  belongs_to :karyawan

  validates :bulan, presence: true
  validates :gaji_pokok, :tunjangan, :potongan, :total_gaji, numericality: { greater_than_or_equal_to: 0 }

  scope :by_karyawan, ->(karyawan_id) { where(karyawan_id: karyawan_id) }
  scope :by_bulan, ->(bulan) { where(bulan: bulan) }

  scope :by_gaji_pokok, ->(value) { where(gaji_pokok: value) }
  scope :by_tunjangan, ->(value) { where(tunjangan: value) }
  scope :by_potongan, ->(value) { where(potongan: value) }
  scope :by_total_gaji, ->(value) { where(total_gaji: value) }

  scope :by_gaji_pokok_range, ->(min, max) { where(gaji_pokok: min..max) }
  scope :by_tunjangan_range, ->(min, max) { where(tunjangan: min..max) }
  scope :by_potongan_range, ->(min, max) { where(potongan: min..max) }
  scope :by_total_gaji_range, ->(min, max) { where(total_gaji: min..max) }
end
