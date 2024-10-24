class Absensi < ApplicationRecord
  self.table_name = "absensi"
  belongs_to :karyawan

  validates :karyawan_id, presence: true
  validates :tanggal, presence: true
  validates :status_absensi, presence: true
  validate :valid_waktu_keluar, if: -> { waktu_keluar.present? }

  enum status_absensi: {
    hadir: 'hadir',
    sakit: 'sakit',
    izin: 'izin',
    alpha: 'alpha'
  }

  scope :by_karyawan_id, ->(karyawan_id) { where(karyawan_id: karyawan_id) }
  scope :by_tanggal, ->(tanggal) { where(tanggal: tanggal) }
  scope :by_status_absensi, ->(status) { where(status_absensi: status) }
  scope :today, -> { where(tanggal: Date.today) }

  def self.apply_filters(params)
    absensi = Absensi.all
    filtered = false

    if params[:karyawan_id].present?
      absensi = absensi.by_karyawan_id(params[:karyawan_id])
      filtered = true
    end

    if params[:tanggal].present?
      absensi = absensi.by_tanggal(Date.parse(params[:tanggal]))
      filtered = true
    end

    if params[:status_absensi].present?
      absensi = absensi.by_status_absensi(params[:status_absensi])
      filtered = true
    end

    return absensi, filtered
  end

  # Class method to handle check-in/check-out logic
  def self.process_attendance(karyawan_id)
    today_attendance = today.find_by(karyawan_id: karyawan_id)

    if today_attendance.nil?
      # First attendance of the day (check-in)
      create!(
        karyawan_id: karyawan_id,
        tanggal: Date.today,
        waktu_masuk: Time.current,
        status_absensi: 'hadir',
        keterangan: 'Regular attendance'
      )
    elsif today_attendance.waktu_keluar.nil?
      # Check-out
      today_attendance.update!(waktu_keluar: Time.current)
      today_attendance
    else
      # Already checked out
      raise StandardError, 'Attendance already completed for today'
    end
  end

  def self.create_with_status(params)
    params[:tanggal] ||= Date.today
    create!(params)
  end

  private

  def valid_waktu_keluar
    if waktu_keluar.present? && waktu_masuk.present? && waktu_keluar < waktu_masuk
      errors.add(:waktu_keluar, "can't be earlier than check-in time")
    end
  end

  def no_duplicate_attendance_for_date
    if Absensi.where(karyawan_id: karyawan_id, tanggal: tanggal).exists?
      errors.add(:base, "Attendance record already exists for this date")
    end
  end

  def valid_status_time_combination
    case status_absensi
    when 'hadir'
      if waktu_masuk.nil?
        errors.add(:waktu_masuk, "must be present for status 'hadir'")
      end
    when 'sakit', 'izin', 'alpha'
      if waktu_masuk.present? || waktu_keluar.present?
        errors.add(:base, "Time entries should be empty for status '#{status_absensi}'")
      end
    end
  end
end