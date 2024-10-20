class AbsensiController < ApplicationController
  include QueryParamCheckAbsensi

  before_action :set_absensi, only: %i[show update destroy]

  def index
    @absensi = filter_absensi(Absensi.all)
    render json: @absensi
  end

  def show
    render json: @absensi
  end

  def create
    @absensi = Absensi.new(absensi_params)

    if @absensi.save
      render json: @absensi, status: :created, location: @absensi
    else
      render json: @absensi.errors, status: :unprocessable_entity
    end
  end

  def update
    if @absensi.update(absensi_update_params)
      render json: @absensi
    else
      render json: @absensi.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @absensi.destroy!
  end

  private

  def set_absensi
    @absensi = Absensi.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Absensi record not found" }, status: :not_found
  end

  def absensi_update_params
    params.require(:absensi).permit(:karyawan_id, :tanggal, :waktu_masuk, :waktu_keluar, :status_absensi)
  end

  def absensi_params
    params.require(:absensi).permit(:karyawan_id, :status_absensi)
  end
end
