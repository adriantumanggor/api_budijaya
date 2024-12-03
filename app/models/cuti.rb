class Cuti < ApplicationRecord
  self.table_name ="cuti"
  # Associations
  belongs_to :karyawan

  validates :tanggal_mulai, presence: true
  validates :tanggal_selesai, presence: true
  validates :jenis_cuti, presence: true, length: { maximum: 50 }
  validates :status, inclusion: { in: %w[menunggu disetujui ditolak], message: "%{value} is not a valid status" }
end
