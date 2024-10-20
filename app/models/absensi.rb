class Absensi < ApplicationRecord
  self.table_name = "absensi"

  belongs_to :karyawan

  validates :tanggal, presence: true
  validates :status_absensi, inclusion: { in: %w[hadir izin sakit alpha], message: "%{value} tidak valid"  }

  before_create :set_default_values

  scope :today_by_karyawan, ->(karyawan_id) { where(karyawan_id: karyawan_id, tanggal: Date.today) }
  scope :by_karyawan, ->(karyawan_id) { where(karyawan_id: karyawan_id) }
  scope :by_tanggal, ->(tanggal) { where(tanggal: tanggal) }
  scope :by_waktu_masuk, ->(waktu) { where("waktu_masuk <= ?", waktu) }
  scope :by_waktu_keluar, ->(waktu) { where("waktu_keluar >= ?", waktu) }
  scope :by_status_absensi, ->(status) { where(status_absensi: status) }

  private

  # Mengisi tanggal, waktu_masuk, atau waktu_keluar, dan default status_absensi menjadi 'hadir'
  def set_default_values
    self.tanggal ||= Date.today
    self.status_absensi ||= "hadir"

    # Cari absensi untuk karyawan di hari ini
    existing_absensi = Absensi.today_by_karyawan(karyawan_id).take  # Gunakan `take` karena kita yakin hanya satu record

    if existing_absensi.nil?
      # Jika belum ada absensi hari ini, buat waktu_masuk baru
      self.waktu_masuk = Time.current
    elsif existing_absensi.waktu_keluar.nil?
      # Jika sudah ada waktu_masuk tapi belum ada waktu_keluar, update waktu_keluar
      existing_absensi.update(waktu_keluar: Time.current)
      throw(:abort)  # Membatalkan pembuatan record baru karena hanya mengupdate waktu_keluar
    else
      # Tidak mungkin ada kondisi lain karena absensi sudah lengkap (masuk dan keluar)
      errors.add(:base, "Absensi untuk hari ini sudah lengkap.")
      throw(:abort)  # Batalkan jika absensi sudah lengkap
    end
  end
end
