# app/serializers/cuti_serializer.rb
class CutiSerializer < ActiveModel::Serializer
    attributes :id, :karyawan_id, :name, :tanggal_mulai, :tanggal_selesai, :jenis_cuti, :status, :durasi

    # Define the `name` attribute by fetching it from the associated `Karyawan` model
    def name
        object.karyawan&.name || "Unknown"
    end
    
    def durasi
        # Calculate the number of days between start and end dates (inclusive)
        working_days = (object.tanggal_mulai..object.tanggal_selesai).count
        
        working_days
    end    
end
  