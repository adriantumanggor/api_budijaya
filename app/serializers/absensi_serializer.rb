# app/serializers/absensi_serializer.rb
class AbsensiSerializer < ActiveModel::Serializer
    attributes :id, :karyawan_id, :tanggal, :waktu_masuk, :waktu_keluar, :status_absensi, :is_complete
  
    def waktu_masuk
      object.waktu_masuk&.strftime("%H:%M")
    end
  
    def waktu_keluar
      object.waktu_keluar&.strftime("%H:%M")
    end
end
  