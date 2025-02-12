# app/controllers/cuti_controller.rb
class CutiController < ApplicationController
  before_action :set_cuti, only: [:show, :update, :destroy]

  # GET /cuti
  def index
    @cuti = Cuti.all.includes(:karyawan)
    render json: @cuti
  end

  # GET /cuti/user/:karyawan_id
  def user_cuti
    @cuti = Cuti.where(karyawan_id: params[:karyawan_id])

    if @cuti.exists?
      render json: @cuti
    else
      render json: { error: "No leave records found for this user" }, status: :not_found
    end
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

  def set_cuti
    @cuti = Cuti.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cuti record not found" }, status: :not_found
  end

  def cuti_params
    params.require(:cuti).permit(:karyawan_id, :tanggal_mulai, :tanggal_selesai, :jenis_cuti, :status)
  end
end
