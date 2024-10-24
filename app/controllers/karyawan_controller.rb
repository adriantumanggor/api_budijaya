
# app/controllers/karyawan_controller.rb
class KaryawanController < ApplicationController
  before_action :set_karyawan, only: %i[show update destroy]

  # GET /karyawan
  def index
    @karyawan, filtered = Karyawan.apply_filters(params)

    # Default sorting by ID ascending
    @karyawan = @karyawan.order(id: :asc)

    # If filters were applied and no results found, return error
    if filtered && @karyawan.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      render json: @karyawan
    end
  end

  # GET /karyawan/:id
  def show
    render json: @karyawan
  end

  # POST /karyawan
  def create
    @karyawan = Karyawan.new(karyawan_params)

    if @karyawan.save
      render json: @karyawan, status: :created, location: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /karyawan/:id
  def update
    if @karyawan.update(karyawan_params)
      render json: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /karyawan/:id (soft delete)
  def destroy
    @karyawan.soft_delete
    head :no_content
  end

  private

  def set_karyawan
    # Allow finding both active and deleted records
    @karyawan = Karyawan.unscoped.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Karyawan record not found" }, status: :not_found
  end

  def karyawan_params
    params.require(:karyawan).permit(
      :nama_lengkap, :email, :nomor_telepon, :tanggal_lahir, 
      :alamat, :tanggal_masuk, :departemen_id, :jabatan_id, 
      :status, :deleted
    )
  end
end