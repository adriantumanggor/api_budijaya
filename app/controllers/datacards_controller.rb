# app/controllers/datacards_controller.rb
class DatacardsController < ApplicationController
    def index  
      # Dynamic data
      total_karyawan = Karyawan.where(deleted: false).count
  
      hadir_hari_ini = Absensi.where(
        status_absensi: "hadir",
        tanggal: Date.today
      ).count
  
      cuti_minggu_ini = Absensi.where(
        status_absensi: "cuti",
        tanggal: Date.today.beginning_of_week..Date.today.end_of_week
      ).count
  
      # Calculate average working hours for the current week
      jam_kerja_records = Absensi.where(
        tanggal: Date.today.beginning_of_week..Date.today.end_of_week
      ).pluck(:waktu_masuk, :waktu_keluar)
  
      total_jam_kerja = jam_kerja_records.sum do |waktu_masuk, waktu_keluar|
        if waktu_masuk && waktu_keluar
          ((waktu_keluar - waktu_masuk) / 3600.0) # Convert seconds to hours
        else
          0
        end
      end
  
      rata_rata_jam_kerja = if jam_kerja_records.size > 0
        total_jam_kerja / jam_kerja_records.size
      else
        0
      end
  
      # Compile response data
      data = [
        { value: total_karyawan, description: "Total karyawan" },
        { value: hadir_hari_ini, description: "kehadiran hari ini" },
        { value: cuti_minggu_ini, description: "Jumlah karyawan yang mengambil cuti minggu ini" },
        { value: "#{rata_rata_jam_kerja.round(2)} jam", description: "Rata-rata jam kerja karyawan minggu ini" }
      ]
  
      render json: data
    end
end
  
  