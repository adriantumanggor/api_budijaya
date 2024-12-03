class User < ApplicationRecord
  has_many :absensi, class_name: "Absensi", foreign_key: :karyawan_id
  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true

  # Setter untuk mengenkripsi password saat disimpan
  def password=(new_password)
    self.password_hash = BCrypt::Password.create(new_password)
  end

  # Metode untuk memeriksa apakah absensi sudah selesai hari ini
  def attendance_completed_today?
    today_absensi = absensi.find_by(tanggal: Date.today)
    return false unless today_absensi

    # Cek apakah absensi sudah selesai
    today_absensi.is_complete || today_absensi.waktu_keluar.present?
  end
end
