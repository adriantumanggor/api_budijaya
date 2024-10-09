class JabatanController < ApplicationController
  before_action :set_jabatan, only: %i[ show update destroy ]

  # GET /jabatan
  def index
    @jabatan = Jabatan.all

    render json: @jabatan
  end

  # GET /jabatan/1
  def show
    render json: @jabatan
  end

  # POST /jabatan
  def create
    @jabatan = Jabatan.new(jabatan_params)

    if @jabatan.save
      render json: @jabatan, status: :created, location: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jabatan/1
  def update
    if @jabatan.update(jabatan_params)
      render json: @jabatan
    else
      render json: @jabatan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /jabatan/1
  def destroy
    @jabatan.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jabatan
      @jabatan = Jabatan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jabatan_params
      params.require(:jabatan).permit(:nama_jabatan)
    end
end
