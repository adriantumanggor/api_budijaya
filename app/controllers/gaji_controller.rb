class GajiController < ApplicationController
  include QueryParamCheckGaji

  before_action :set_gaji, only: %i[show update destroy]

  def index
    @gaji = filter_gaji(Gaji.all)
    render json: @gaji
  end

  def show
    render json: @gaji
  end

  def create
    @gaji = Gaji.new(gaji_params)

    if @gaji.save
      render json: @gaji, status: :created, location: @gaji
    else
      render json: @gaji.errors, status: :unprocessable_entity
    end
  end

  def update
    if @gaji.update(gaji_params)
      render json: @gaji
    else
      render json: @gaji.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @gaji.destroy
    head :no_content
  end

  private

  def set_gaji
    @gaji = Gaji.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Gaji record not found' }, status: :not_found
  end

  def gaji_params
    params.require(:gaji).permit(:karyawan_id, :bulan, :gaji_pokok, :tunjangan, :potongan, :total_gaji)
  end
end