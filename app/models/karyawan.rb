# app/models/karyawan.rb
class Karyawan < ApplicationRecord
  self.table_name = "karyawan"

  belongs_to :departemen, class_name: "Departemen"
  belongs_to :jabatan, class_name: "Jabatan"
  has_many :absensi, class_name: "Absensi"
  has_many :gaji, class_name: "Gaji"

  # Normalisasi sebelum validasi
  before_validation :normalize_email
  before_save :normalize_nomor_telepon

  # Validasi
  validates :nama_lengkap, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates :nomor_telepon, length: { maximum: 15 }, allow_blank: true

  # Enum untuk status
  enum status: { aktif: 'aktif', nonaktif: 'nonaktif' }

  # Scopes for active and deleted records
  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  # Scope untuk filter data - menggunakan exact match
  scope :by_nama, ->(nama) { where(nama_lengkap: nama) }
  scope :by_email, ->(email) { where(email: email.downcase) }
  scope :by_nomor_telepon, ->(nomor) { where(nomor_telepon: nomor) }
  scope :by_tanggal_lahir, ->(tanggal) { where(tanggal_lahir: tanggal) }
  scope :by_alamat, ->(alamat) { where(alamat: alamat) }
  scope :by_tanggal_masuk, ->(tanggal) { where(tanggal_masuk: tanggal) }
  scope :by_departemen_id, ->(departemen_id) { where(departemen_id: departemen_id) }
  scope :by_jabatan_id, ->(jabatan_id) { where(jabatan_id: jabatan_id) }
  scope :by_status, ->(status) { where(status: status) }

  def self.apply_filters(params)
    # Start with base scope based on status parameter
    karyawan = if params[:status] == 'deleted'
                 self.deleted
               else
                 self.active
               end
    
    filtered = false

    if params[:nama].present?
      karyawan = karyawan.by_nama(params[:nama])
      filtered = true
    end

    if params[:email].present?
      karyawan = karyawan.by_email(params[:email])
      filtered = true
    end

    if params[:departemen_id].present?
      karyawan = karyawan.by_departemen_id(params[:departemen_id])
      filtered = true
    end

    if params[:jabatan_id].present?
      karyawan = karyawan.by_jabatan_id(params[:jabatan_id])
      filtered = true
    end

    if params[:status].present? && params[:status] != 'deleted'  # Ignore status filter if it's 'deleted'
      karyawan = karyawan.by_status(params[:status])
      filtered = true
    end

    return karyawan, filtered
  end

  # Soft delete method
  def soft_delete
    update(deleted: true)
  end

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end

  def normalize_nomor_telepon
    self.nomor_telepon = nil if nomor_telepon.blank?
  end
end
