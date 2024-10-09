class GajiController < ApplicationController
  before_action :set_gaji, only: %i[ show update destroy ]

  # GET /gaji
  def index
    @gaji = Gaji.all

    render json: @gaji
  end

  # GET /gaji/1
  def show
    render json: @gaji
  end

  # POST /gaji
  def create
    @gaji = Gaji.new(gaji_params)

    if @gaji.save
      render json: @gaji, status: :created, location: @gaji
    else
      render json: @gaji.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /gaji/1
  def update
    if @gaji.update(gaji_params)
      render json: @gaji
    else
      render json: @gaji.errors, status: :unprocessable_entity
    end
  end

  # DELETE /gaji/1
  def destroy
    @gaji.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gaji
      @gaji = Gaji.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gaji_params
      params.require(:gaji).permit(:karyawan_id, :bulan, :gaji_pokok, :tunjangan, :potongan, :total_gaji)
    end
end
