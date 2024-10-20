class KaryawanController < ApplicationController
  include QueryParamCheckKaryawan

  before_action :set_karyawan, only: %i[show update destroy]

  def index
    @karyawan = filter_karyawan(Karyawan.all)
    render json: @karyawan
  end

  def show
    render json: @karyawan
  end

  def create
    @karyawan = Karyawan.new(karyawan_params)

    if @karyawan.save
      render json: @karyawan, status: :created, location: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @karyawan.update(karyawan_params)
      render json: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @karyawan.soft_delete
  end

  private

  def set_karyawan
    @karyawan = Karyawan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Karyawan record not found" }, status: :not_found
  end

  def karyawan_params
    params.require(:karyawan).permit(:nama_lengkap, :email, :nomor_telepon, :tanggal_lahir, :alamat, :tanggal_masuk, :departemen_id, :jabatan_id, :status)
  end
end
