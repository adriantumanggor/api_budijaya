# app/controllers/cuti_controller.rb
class CutiController < ApplicationController
  before_action :set_cuti, only: [:show, :update, :destroy]

  # GET /cuti
  def index
    @cuti = Cuti.all
    render json: @cuti
  end

  # GET /cuti/:id
  def show
    render json: @cuti
  end

  # POST /cuti
  def create
    @cuti = Cuti.new(cuti_params)

    if @cuti.save
      render json: @cuti, status: :created
    else
      render json: @cuti.errors, status: :unprocessable_entity
    end
  end

  # PUT /cuti/:id
  def update
    if @cuti.update(cuti_params)
      render json: @cuti
    else
      render json: @cuti.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cuti/:id
  def destroy
    @cuti.destroy
    head :no_content
  end

  private

  # Find a specific `cuti` by ID
  def set_cuti
    @cuti = Cuti.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cuti not found" }, status: :not_found
  end

  # Strong parameters for `cuti`
  def cuti_params
    params.require(:cuti).permit(:karyawan_id, :tanggal_mulai, :tanggal_selesai, :jenis_cuti, :status)
  end
end
