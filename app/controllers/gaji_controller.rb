class GajiController < ApplicationController
  before_action :set_gaji, only: %i[show update destroy]

  def index
    @gaji, filtered = Gaji.apply_filters(params)

    # Default sorting by ID ascending
    @gaji = @gaji.order(id: :asc)

    # If filters were applied and no results found, return error
    if filtered && @gaji.empty?
      render json: { 
        error: "No exact match found for the given criteria",
        message: "Please ensure your search criteria exactly matches the records in the database"
      }, status: :not_found
    else
      render json: @gaji
    end
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
    render json: { error: "Gaji record not found" }, status: :not_found
  end

  def gaji_params
    params.require(:gaji).permit(:karyawan_id, :bulan, :gaji_pokok, :tunjangan, :potongan, :total_gaji)
  end
end
