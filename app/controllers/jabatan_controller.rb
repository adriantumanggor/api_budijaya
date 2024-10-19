class JabatanController < ApplicationController
  include QueryParamCheckJabatan

  before_action :set_jabatan, only: %i[show update destroy]

  def index
    @jabatan = filter_jabatan(Jabatan.all)
    render json: @jabatan
  end

  def show
    render json: @jabatan
  end

  def create
    @jabatan = Jabatan.new(jabatan_params)

    if @jabatan.save
      render json: @jabatan, status: :created, location: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @jabatan.update(jabatan_params)
      render json: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @jabatan.destroy
  end

  private

  def set_jabatan
    @jabatan = Jabatan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Jabatan record not found" }, status: :not_found
  end

  def jabatan_params
    params.require(:jabatan).permit(:nama_jabatan)
  end
end
