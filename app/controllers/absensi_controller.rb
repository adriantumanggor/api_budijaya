class AbsensiController < ApplicationController
  before_action :set_absensi, only: %i[show update destroy]

  def index
    @absensi, filtered = Absensi.apply_filters(params)

    @absensi = @absensi.order(id: :asc)

    if filtered && @absensi.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      render json: @absensi
    end
  end

  def show
    render json: @absensi
  end

  def create
    begin
      params[:absensi][:status_absensi] ||= 'hadir'

      @absensi = if params[:absensi][:status_absensi] == 'hadir'
        Absensi.process_attendance(absensi_params[:karyawan_id])
      else
        Absensi.create_with_status(absensi_params)
      end

      render json: @absensi, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    end
  end  
  
  def update
    if @absensi.update(absensi_params)
      render json: @absensi
    else
      render json: @absensi.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @absensi.destroy!
    head :no_content
  end

  private

  def set_absensi
    @absensi = Absensi.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Absensi record not found" }, status: :not_found
  end

  def absensi_params
    params.require(:absensi).permit(:karyawan_id, :tanggal, :waktu_masuk, :waktu_keluar, :status_absensi)
  end
end