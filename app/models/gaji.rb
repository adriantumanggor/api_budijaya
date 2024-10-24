class Gaji < ApplicationRecord
  self.table_name = "gaji"

  belongs_to :karyawan

  validates :bulan, presence: true
  validates :gaji_pokok, :tunjangan, :potongan, numericality: { greater_than_or_equal_to: 0 }

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

  def self.apply_filters(params)
    gaji = Gaji.all
    filtered = false

    if params[:karyawan_id].present?
      gaji = gaji.by_karyawan(params[:karyawan_id])
      filtered = true
    end

    if params[:bulan].present?
      gaji = gaji.by_bulan(params[:bulan])
      filtered = true
    end

    if params[:gaji_pokok_min].present? && params[:gaji_pokok_max].present?
      gaji = gaji.by_gaji_pokok_range(params[:gaji_pokok_min], params[:gaji_pokok_max])
      filtered = true
    end

    if params[:tunjangan_min].present? && params[:tunjangan_max].present?
      gaji = gaji.by_tunjangan_range(params[:tunjangan_min], params[:tunjangan_max])
      filtered = true
    end

    if params[:potongan_min].present? && params[:potongan_max].present?
      gaji = gaji.by_potongan_range(params[:potongan_min], params[:potongan_max])
      filtered = true
    end

    if params[:total_gaji_min].present? && params[:total_gaji_max].present?
      gaji = gaji.by_total_gaji_range(params[:total_gaji_min], params[:total_gaji_max])
      filtered = true
    end

    return gaji, filtered
  end
end
