class AbsensiController < ApplicationController
  before_action :set_absensi, only: [:show, :update, :destroy]

  # GET /absensi
  def index
    absensi = Absensi.all
    render json: absensi, each_serializer: AbsensiSerializer
  end

  # GET /absensi/:id
  def show
    render json: @absensi, serializer: AbsensiSerializer
  end

  # POST /absensi
  def create
    # Menangani absensi dengan process_attendance
    absensi = Absensi.process_attendance(absensi_params[:karyawan_id])

    render json: absensi, serializer: AbsensiSerializer, status: :created
  end


  # PATCH/PUT /absensi/:id
  def update
    if @absensi.update(absensi_params)
      render json: @absensi, serializer: AbsensiSerializer
    else
      render json: { errors: @absensi.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /absensi/:id
  def destroy
    @absensi.destroy
    head :no_content
  end

  private

  # Set absensi by ID
  def set_absensi
    @absensi = Absensi.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Record not found' }, status: :not_found
  end

  # Strong parameters
  def absensi_params
    params.permit(:karyawan_id, :tanggal, :waktu_masuk, :waktu_keluar, :status_absensi)
  end
end
