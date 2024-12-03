class Absensi < ApplicationRecord
  self.table_name = "absensi"
  belongs_to :karyawan

  # Validasi atribut
  validates :karyawan_id, presence: true
  validates :tanggal, presence: true
  validate :validate_waktu_keluar_sequence

  # Scope untuk keperluan query
  scope :by_karyawan_id, ->(karyawan_id) { where(karyawan_id: karyawan_id) }
  scope :today, -> { where(tanggal: Date.today) }

  # Method untuk proses absensi
  def self.process_attendance(karyawan_id)
    today_attendance = today.find_by(karyawan_id: karyawan_id)

    if today_attendance.nil?
      # Check-in (waktu masuk)
      create!(
        karyawan_id: karyawan_id,
        tanggal: Date.today,
        waktu_masuk: Time.current.strftime("%H:%M") # Rails menangani waktu
      )
    elsif today_attendance.waktu_keluar.nil?
      # Check-out (waktu keluar)
      today_attendance.update!(waktu_keluar: Time.current.strftime("%H:%M"))
      today_attendance
    else
      # Jika sudah check-out
      raise StandardError, 'Attendance already completed for today'
    end
  end

  def is_complete
    waktu_masuk.present? && waktu_keluar.present?
  end

  private

  # Validasi untuk memastikan urutan waktu masuk dan keluar logis
  def validate_waktu_keluar_sequence
    if waktu_keluar.present? && waktu_masuk.blank?
      errors.add(:waktu_keluar, "cannot be set without waktu_masuk")
    end
  end
end
