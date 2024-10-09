class KaryawanController < ApplicationController
  before_action :set_karyawan, only: %i[ show update destroy ]

  # GET /karyawan
  def index
    @karyawan = Karyawan.all

    render json: @karyawan
  end

  # GET /karyawan/1
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

  # PATCH/PUT /karyawan/1
  def update
    if @karyawan.update(karyawan_params)
      render json: @karyawan
    else
      render json: @karyawan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /karyawan/1
  def destroy
    @karyawan.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_karyawan
      @karyawan = Karyawan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def karyawan_params
      params.fetch(:karyawan, {})
    end
end
