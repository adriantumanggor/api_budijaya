class AbsensiController < ApplicationController
  before_action :set_absensi, only: %i[ show update destroy ]

  # GET /absensi
  def index
    @absensi = Absensi.all

    render json: @absensi
  end

  # GET /absensi/1
  def show
    render json: @absensi
  end

  # POST /absensi
  def create
    @absensi = Absensi.new(absensi_params)

    if @absensi.save
      render json: @absensi, status: :created, location: @absensi
    else
      render json: @absensi.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /absensi/1
  def update
    if @absensi.update(absensi_params)
      render json: @absensi
    else
      render json: @absensi.errors, status: :unprocessable_entity
    end
  end

  # DELETE /absensi/1
  def destroy
    @absensi.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_absensi
      @absensi = Absensi.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def absensi_params
      params.fetch(:absensi, {})
    end
end
